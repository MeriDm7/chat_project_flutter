import 'package:chat/models/chat_message.dart';
import 'package:chat/models/chat_user.dart';

class Chat {
  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  List<ChatMessage> messages;

  late final List<ChatUser> _recepients;
  final String? groupName;
  final String? groupImageURL;

  Chat(
    this.groupName,
    this.groupImageURL, {
    required this.uid,
    required this.currentUserUid,
    required this.members,
    required this.messages,
    required this.activity,
    required this.group,
  }) {
    _recepients = members.where((_i) => _i.uid != currentUserUid).toList();
  }

  List<ChatUser> recepients() {
    return _recepients;
  }

  String title() {
    return !group ? _recepients.first.name : groupName!;
  }

  String imageURL() {
    return !group ? _recepients.first.imageURL : groupImageURL!;
  }
}
