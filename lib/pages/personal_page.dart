import 'package:chat/services/media_service.dart';
import 'package:chat/widgets/custom_colors.dart';
import 'package:chat/widgets/gradient_button.dart';
import 'package:chat/widgets/gradient_text.dart';
import 'package:chat/widgets/rounded_image.dart';

import 'package:flutter/material.dart';

import 'package:chat/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PersonalPage();
  }
}

class _PersonalPage extends State<PersonalPage> {
  late double _deviceHeight;
  late double _deviceWigth;
  late AuthenticationProvider _auth;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);

    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWigth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              stops: [0.1, 0.3, 0.6],
              colors: [neored, darkpurple, newblue],
              center: Alignment(0.6, -0.3),
              focal: Alignment(0.3, -0.1),
              focalRadius: 1.2,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWigth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight * 0.98,
          width: _deviceWigth * 0.97,
          child: Column(children: [
            _pageTitle(),
            SizedBox(
              height: _deviceHeight * 0.07,
            ),
            _myPhoto(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _myName(),
            _myEmail(),
            SizedBox(
              height: _deviceHeight * 0.2,
            ),
            _logOut(),
          ]));
    });
  }

  Widget _pageTitle() {
    return Container(
      height: _deviceHeight * 0.1,
      alignment: Alignment.centerLeft,
      child: GradientText(
        "PERSONAL PAGE",
        style: const TextStyle(fontSize: 40, fontFamily: "it"),
        gradient: LinearGradient(colors: [Colors.white, neored, neopink]),
      ),
    );
  }

  Widget _myPhoto() {
    return RoundedImageNetwork(
      key: UniqueKey(),
      imagePath: _auth.user.imageURL,
      size: _deviceHeight * 0.13,
    );
  }

  Widget _myName() {
    return Container(
        height: _deviceHeight * 0.1,
        alignment: Alignment.center,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const Text("NAME: ",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'it',
                  color: Color.fromRGBO(255, 255, 255, 0.5))),
          GradientText(
            _auth.user.name.toString(),
            style: const TextStyle(fontSize: 22, fontFamily: "th"),
            gradient:
                const LinearGradient(colors: [Colors.white, Colors.white]),
          ),
        ]));
  }

  Widget _myEmail() {
    return Container(
        height: _deviceHeight * 0.1,
        alignment: Alignment.center,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const Text("EMAIL: ",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'it',
                  color: Color.fromRGBO(255, 255, 255, 0.5))),
          GradientText(
            _auth.user.email.toString(),
            style: const TextStyle(fontSize: 22, fontFamily: "th"),
            gradient:
                const LinearGradient(colors: [Colors.white, Colors.white]),
          ),
        ]));
  }

  Widget _logOut() {
    return Container(
      child: GradientButton(
        name: "LOGOUT",
        onPressed: () {
          _auth.logout();
        },
      ),
    );
  }
}



//Widget _profileImage() {
  //return Container(
  //    child: ClipOval(
  //  child: Image.file(
      //File(),
    //  fit: BoxFit.cover,
   //r ),));}
