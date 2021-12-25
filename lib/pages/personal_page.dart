import 'package:chat/models/chat_user.dart';
import 'package:chat/providers/chats_page_provider.dart';
import 'package:chat/providers/users_page_provider.dart';
import 'package:chat/widgets/custom_input_fields.dart';
import 'package:chat/widgets/custom_colors.dart';
import 'package:chat/widgets/gradient_button.dart';
import 'package:chat/widgets/gradient_text.dart';

import 'package:chat/widgets/custom_list_view_tiles.dart';
import 'package:chat/widgets/rounded_button.dart';
import 'package:chat/widgets/top_bar.dart';
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
  late AuthenticationProvider _auth;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);

    return _buildUI();
  }

  Widget _buildUI() {
    return Container(
      child: IconButton(
        icon: const Icon(
          Icons.logout,
          color: Color.fromRGBO(0, 82, 218, 1.0),
        ),
        onPressed: () {
          _auth.logout();
        },
      ),
    );
  }
}
