import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
  bool emojiShowing = true;
  double message_box_multiplier = 0.74;

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
                    onPressed: () {
                      _pageProvider.deleteChat();
                    },
                  ),
                  secondaryAction: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(0, 82, 218, 1.0),
                    ),
                    onPressed: () {
                      _pageProvider.goBack();
                    },
                  ),
                ),
                _messagesListView(),
                _sendMessageForm(),
                Offstage(
                  offstage: !emojiShowing,
                  child: SizedBox(
                    height: _deviceHeight * 0.2,
                    child: EmojiPicker(
                        onEmojiSelected: (Category category, Emoji emoji) {
                          _pageProvider.onEmojiSelected(emoji);
                        },
                        onBackspacePressed: _pageProvider.onBackspacePressed,
                        config: Config(
                            columns: 7,
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            initCategory: Category.RECENT,
                            bgColor: const Color(0xFFF2F2F2),
                            indicatorColor: Colors.blue,
                            iconColor: Colors.grey,
                            iconColorSelected: Colors.blue,
                            progressIndicatorColor: Colors.blue,
                            backspaceColor: Colors.blue,
                            showRecentsTab: true,
                            recentsLimit: 28,
                            noRecentsText: 'No Recents',
                            noRecentsStyle: const TextStyle(
                                fontSize: 20, color: Colors.black26),
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            categoryIcons: const CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL)),
                  ),
                ),
              ],
            )),
      ));
    });
  }

  Widget _messagesListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.isNotEmpty) {
        return Container(
          height: _deviceHeight * message_box_multiplier,
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
            "Be the first to say Hi!",
            style: TextStyle(color: Colors.white),
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
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
          color: Color.fromRGBO(30, 29, 37, 1.0),
          borderRadius: BorderRadius.circular(100)),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWight * 0.04,
        vertical: _deviceHeight * 0.03,
      ),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _addEmojiButton(),
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWight * 0.6,
      child: ChatTextFromField(
        onSaved: (_value) {
          _pageProvider.message = _value;
        },
        regEx: r"^(?!\s*$).+",
        hintText: "Type a message",
        obscureText: false,
      ),
    );
  }

  Widget _sendMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: IconButton(
        icon: const Icon(Icons.send, color: Colors.white),
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

  Widget _imageMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(0, 82, 218, 1.0),
        onPressed: () {
          _pageProvider.sendImageMessage();
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _addEmojiButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(42, 82, 218, 1.0),
        heroTag: 434829,
        onPressed: () {
          emojiShowing = !emojiShowing;
          if (emojiShowing) {
            message_box_multiplier = 0.5;
          } else {
            message_box_multiplier = 0.74;
          }
        },
        child: Icon(Icons.emoji_emotions),
      ),
    );
  }
}
