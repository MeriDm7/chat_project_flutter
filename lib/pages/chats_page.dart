import 'package:chat/models/chat_message.dart';
import 'package:chat/models/chat_user.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/providers/chats_page_provider.dart';
import 'package:flutter/material.dart';

import 'package:chat/providers/authentication_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/navigation_service.dart';

import '../widgets/top_bar.dart';
import 'package:chat/widgets/custom_list_view_tiles.dart';
import '../widgets/custom_colors.dart';
import '../widgets/gradient_text.dart';

import 'package:chat/models/chat.dart';

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
  late NavigationService _navigation;
  late ChatsPageProvider _pageProvider;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWight = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _pageProvider = _context.watch<ChatsPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWight * 0.03, vertical: _deviceHeight * 0.02),
        height: _deviceHeight * 0.98,
        width: _deviceWight * 0.97,
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pageTitle(),
            _chatsList(),
          ],
        ),
      );
    });
  }

  Widget _pageTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      height: _deviceHeight * 0.1,
      child: GradientText(
        'CHATS',
        style: const TextStyle(fontSize: 40, fontFamily: "it"),
        gradient: LinearGradient(colors: [Colors.white, neored, neopink]),
      ),
    );
  }

  Widget _chatsList() {
    List<Chat>? _chats = _pageProvider.chats;
    return Expanded(
      child: (() {
        if (_chats != null) {
          if (_chats.isNotEmpty) {
            return ListView.builder(
                itemCount: _chats.length,
                itemBuilder: (BuildContext _context, int _index) {
                  return _chatTile(
                    _chats[_index],
                  );
                });
          } else {
            return const Center(
              child: Text(
                "No Chats Found.",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'th',
                  color: Colors.white,
                ),
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
      })(),
    );
  }

  Widget _chatTile(Chat _chat) {
    List<ChatUser> _recepients = _chat.recepients();
    bool _isActive = _recepients.any((_d) => _d.wasRecentlyActive());
    String _subtitleText = "";
    if (_chat.messages.isNotEmpty) {
      _subtitleText = _chat.messages.first.type != MessageType.text
          ? "Media Attachment"
          : _chat.messages.first.content;
    }

    return CustomListViewTileWithActivity(
      height: _deviceHeight * 0.10,
      title: _chat.title(),
      subtitle: _subtitleText,
      imagePath: _chat.imageURL(),
      isActive: _isActive,
      isActivity: _chat.activity,
      onTap: () {
        _navigation.navigateToPage(
          ChatPage(chat: _chat),
        );
      },
    );
  }
}
