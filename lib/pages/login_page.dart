// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

// Widgets
import '../widgets/custom_input_fields.dart';
import '../widgets/gradient_button.dart';
import '../widgets/gradient_text.dart';
import '../widgets/gradient_background.dart';

//Providers
import '../providers/authentication_provider.dart';

// Services
import '../services/navigation_service.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late NavigationService _navigation;
  static const darkpurple = const Color(0xFF400085);
  static const newblue = const Color(0xFF0f0238);

  static const neored = const Color(0xFFff0217);
  static const neopink = const Color(0xFFf41c74);
  static const neopuprle = const Color(0xFFff32ff);

  final _loginFormKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            stops: [0.1, 0.3, 0.6],
            colors: [neored, darkpurple, newblue],
            center: Alignment(0.6, -0.3),
            focal: Alignment(0.3, -0.1),
            focalRadius: 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pageTitle(),
            SizedBox(
              height: _deviceHeight * 0.04,
            ),
            _loginForm(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _loginButton(),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            _registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return Container(
      height: _deviceHeight * 0.10,
      child: GradientText(
        'HELLO <3 FLUTTER',
        style: const TextStyle(fontSize: 40, fontFamily: "it"),
        gradient: LinearGradient(colors: [
          Colors.white,
          neopuprle,
          Colors.white,
          neored,
          Colors.white,
          neopink
        ]),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: _deviceHeight * 0.25,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
                onSaved: (_value) {
                  setState(() {
                    _email = _value;
                  });
                },
                regEx:
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                hintText: "Email",
                obscureText: false),
            CustomTextFormField(
                onSaved: (_value) {
                  setState(() {
                    _password = _value;
                  });
                },
                regEx: r".{8,}",
                hintText: "Password",
                obscureText: true)
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return GradientButton(
      name: "LOGIN",
      onPressed: () {
        if (_loginFormKey.currentState!.validate()) {
          print("lol");
          //print("Email: $_email, password: $_password");
          _loginFormKey.currentState!.save();
          print("lol33");

          // print("Email: $_email, password: $_password");
          _auth.loginUsingEmailAndPassword(_email!, _password!);
          print("lol3");
        }
      },
    );
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () => _navigation.navigateToRoute('/register'),
      child: Container(
        child: Text(
          "don\'t have an account ?",
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'th',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
