import 'package:chat/widgets/gradient_button.dart';
import 'package:chat/widgets/gradient_text.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat/widgets/top_bar.dart';
import 'package:chat/widgets/custom_list_view_tiles.dart';
import 'package:chat/widgets/custom_input_fields.dart';
import 'package:chat/widgets/gradient_button.dart';
import 'package:chat/widgets/custom_colors.dart';

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
            decoration: BoxDecoration(
              gradient: RadialGradient(
                stops: [0.1, 0.3, 0.6],
                colors: [neored, darkpurple, newblue],
                center: Alignment(0.6, -0.3),
                focal: Alignment(0.3, -0.1),
                focalRadius: 1.2,
              ),
            ),
            height: _deviceHeight,
            width: _deviceWight * 0.97,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _topBar(),
                _messagesListView(),
                _sendMessageForm(),
              ],
            )),
      ));
    });
  }

  Widget _topBar() {
    return Container(
      child: Form(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _deleteButton(),
            _pageTitle(),
            _backArrow(),
          ],
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return Container(
      width: _deviceWight * 0.5,
      height: _deviceHeight * 0.1,
      alignment: Alignment.centerLeft,
      child: GradientText(
        widget.chat.title(),
        style: const TextStyle(fontSize: 30, fontFamily: "th"),
        gradient: LinearGradient(colors: [Colors.white, Colors.white]),
      ),
    );
  }

  Widget _backArrow() {
    return Container(
        width: _deviceWight * 0.2,
        child: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Color.fromRGBO(255, 255, 255, 1.0),
          ),
          onPressed: () {
            _pageProvider.deleteChat();
          },
        ));
  }

  Widget _deleteButton() {
    return Container(
        width: _deviceWight * 0.2,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(255, 255, 255, 1.0),
          ),
          onPressed: () {
            _pageProvider.goBack();
          },
        ));
  }

  Widget _messagesListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.isNotEmpty) {
        return Container(
          height: _deviceHeight * 0.74,
          child: ListView.builder(
            controller: _messagesListViewController,
            itemCount: _pageProvider.messages!.length,
            itemBuilder: (BuildContext _context, int _index) {
              ChatMessage _message = _pageProvider.messages![_index];
              bool _isOwnMessage = _message.senderID == _auth.user.uid;
              return Container(
                child: CustomChatListViewTile(
                  deviceHeight: _deviceHeight,
                  width: _deviceWight * 0.80,
                  message: _message,
                  isOwnMessage: _isOwnMessage,
                  sender: widget.chat.members
                      .where((_m) => _m.uid == _message.senderID)
                      .first,
                ),
              );
            },
          ),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            "WHY ARE YOU SO QUIET?",
            style:
                TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'th'),
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
  }

  Widget _sendMessageForm() {
    return Container(
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _imageMessageButton(),
            _messageTextField(),
            _sendMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _imageMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          _pageProvider.sendImageMessage();
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      height: _deviceHeight * 0.07,
      width: _deviceWight * 0.60,
      child: CustomTextFormField(
        onSaved: (_value) {
          _pageProvider.message = _value;
        },
        regEx: r"^(?!\s*$).+",
        hintText: "type a message",
        obscureText: false,
      ),
    );
  }

  Widget _sendMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      child: GradientButton(
        name: "SEND",
        onPressed: () {
          if (_messageFormState.currentState!.validate()) {
            _messageFormState.currentState!.save();
            _pageProvider.sendTextMessage();
            _messageFormState.currentState!.reset();
          }
        },
      ),
    );
  }
}
