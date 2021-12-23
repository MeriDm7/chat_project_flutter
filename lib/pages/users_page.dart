import 'package:chat/widgets/custom_input_fields.dart';
import 'package:chat/widgets/top_bar.dart';
import 'package:flutter/material.dart';

import 'package:chat/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UsersPageState();
  }
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceHeight;
  late double _deviceWigth;

  late AuthenticationProvider _auth;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWigth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return _buildUI();
  }

  Widget _buildUI() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWigth * 0.03,
        vertical: _deviceHeight * 0.02,
      ),
      height: _deviceHeight * 0.98,
      width: _deviceWigth * 0.97,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TopBar(
            "Users",
            primaryAction: IconButton(
              icon: const Icon(
                Icons.logout,
                color: Color.fromRGBO(0, 82, 218, 1.0),
              ),
              onPressed: () {
                _auth.logout();
              },
            ),
          ),
          CustomTextField(
            onEditingComplete: (_value) {},
            hintText: "Search..",
            obscureText: false,
            controller: _searchFieldTextEditingController,
            icon: Icons.search,
          ),
        ],
      ),
    );
  }
}
