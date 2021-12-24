import 'package:chat/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:chat/widgets/custom_colors.dart';

class TextMessageBuble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  const TextMessageBuble(
      {Key? key,
      required this.isOwnMessage,
      required this.message,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height + (message.content.length / 20 * 6.0),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: <Color>[white, tr])),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            message.content,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: 'it',
              color: Colors.white,
            ),
          ),
          Text(
            message.sentTime.toString().substring(11, 16),
            style: const TextStyle(
              fontFamily: 'th',
              color: const Color.fromRGBO(255, 255, 255, 0.3),
            ),
          )
        ],
      ),
    );
  }
}

class ImageMessageBuble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  const ImageMessageBuble(
      {Key? key,
      required this.isOwnMessage,
      required this.message,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DecorationImage _image = DecorationImage(
      image: NetworkImage(message.content),
      fit: BoxFit.cover,
    );
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: height * 0.03,
      ),
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: _image,
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Text(
            message.sentTime.toString().substring(11, 16),
            style: const TextStyle(
              fontFamily: 'th',
              color: const Color.fromRGBO(255, 255, 255, 0.5),
            ),
          )
        ],
      ),
    );
  }
}
