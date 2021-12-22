import 'package:flutter/material.dart';

import 'package:chat/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/top_bar.dart';
import 'package:chat/widgets/custom_list_view_tiles.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatsPageState();
  }
}

class _ChatsPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWight;

  late AuthenticationProvider _auth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWight = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    return _buildUI();
  }

  Widget _buildUI() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: _deviceWight * 0.03, vertical: _deviceHeight * 0.02),
      height: _deviceHeight * 0.98,
      width: _deviceWight * 0.97,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TopBar(
            'Chats',
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
          CustomListViewTileWithActivity(
              height: _deviceHeight * 0.10,
              title: "Hussain Mustafa",
              subtitle: "Hello",
              imagePath: "https://i.pravatar.cc/300",
              isActive: false,
              isActivity: false,
              onTap: () {}),
        ],
      ),
    );
  }
}
