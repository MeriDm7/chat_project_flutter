import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat/widgets/top_bar.dart';
import 'package:chat/widgets/custom_list_view_tiles.dart';
import 'package:chat/widgets/custom_input_fields.dart';

import 'package:chat/models/chat.dart';
import 'package:chat/models/chat_message.dart';

import 'package:chat/providers/authentication_provider.dart';
import 'package:chat/providers/chat_page_provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  ChatPage({required this.chat});

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWight;

  late AuthenticationProvider _auth;
  late ChatPageProvider _pageProvider;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWight = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(
              widget.chat.uid, _auth, _messagesListViewController),
        )
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _pageProvider = _context.watch<ChatPageProvider>();
      return Scaffold(
          body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: _deviceWight * 0.03,
                vertical: _deviceHeight * 0.02),
            height: _deviceHeight,
            width: _deviceWight * 0.97,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TopBar(
                  widget.chat.title(),
                  fontSize: 15,
                  primaryAction: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Color.fromRGBO(0, 82, 218, 1.0),
                    ),
                    onPressed: () {},
                  ),
                  secondaryAction: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(0, 82, 218, 1.0),
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            )),
      ));
    });
  }
}
