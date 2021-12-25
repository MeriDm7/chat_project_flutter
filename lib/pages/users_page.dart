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
  late UsersPageProvider _pageProvider;
  late ChatsPageProvider _chatsProvider;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWigth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(_auth),
        ),
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(_auth),
        )
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _pageProvider = _context.watch<UsersPageProvider>();
      _chatsProvider = _context.watch<ChatsPageProvider>();
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pageTitle(),
            _search(),
            _usersList(),
            _createChatButton(),
          ],
        ),
      );
    });
  }

  Widget _pageTitle() {
    return Container(
      height: _deviceHeight * 0.1,
      alignment: Alignment.centerLeft,
      child: GradientText(
        "USERS",
        style: const TextStyle(fontSize: 40, fontFamily: "it"),
        gradient: LinearGradient(colors: [Colors.white, neored, neopink]),
      ),
    );
  }

  Widget _search() {
    return SizedBox(
      height: _deviceHeight * 0.07,
      child: CustomTextField(
        onEditingComplete: (_value) {
          _pageProvider.getUsers(name: _value);
          FocusScope.of(context).unfocus();
        },
        hintText: "Search..",
        obscureText: false,
        controller: _searchFieldTextEditingController,
        icon: Icons.search,
      ),
    );
  }

  Widget _usersList() {
    List<ChatUser>? _users = _pageProvider.users;
    return Expanded(child: () {
      if (_users != null) {
        if (_users.isNotEmpty) {
          return ListView.builder(
            itemCount: _users.length,
            itemBuilder: (BuildContext _context, int _index) {
              return CustomListViewTile(
                height: _deviceHeight * 0.10,
                title: _users[_index].name,
                subtitle: "Last Active: ${_users[_index].lastDayActive()}",
                imagePath: _users[_index].imageURL,
                isActive: _users[_index].wasRecentlyActive(),
                isSelected:
                    _pageProvider.selectedUsers.contains(_users[_index]),
                onTap: () {
                  _pageProvider.updateSelectedUsers(_users[_index]);
                },
              );
            },
          );
        } else {
          return const Center(
            child: Text(
              "NO USERS FOUND",
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: 'th'),
            ),
          );
        }
      } else {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      }
    }());
  }

  Widget _createChatButton() {
    return Visibility(
      visible: _pageProvider.selectedUsers.isNotEmpty,
      child: GradientButton(
          name: _pageProvider.selectedUsers.length == 1
              ? "CREATE CHAT"
              : "CREATE GROUP CHAT",
          onPressed: () {
            _pageProvider.createChat(chats: _chatsProvider.chats);
          }),
    );
  }
}
