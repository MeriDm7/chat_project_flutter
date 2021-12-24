import 'package:chat/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat/services/database_service.dart';
import 'package:chat/services/navigation_service.dart';

import 'package:chat/models/chat.dart';
import 'package:chat/models/chat_user.dart';

import 'package:chat/pages/chat_page.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;

  late DatabaseService _db;
  late NavigationService _navigation;

  List<ChatUser>? users;
  late List<ChatUser> _selectedUsers;

  List<ChatUser> get selectedUsers {
    return _selectedUsers;
  }

  UsersPageProvider(this._auth) {
    _selectedUsers = [];
    _db = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    _selectedUsers = [];
    try {
      _db.getUsers(name: name).then(
        (_snapshot) {
          users = _snapshot.docs.map(
            (_doc) {
              Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
              _data["uid"] = _doc.id;
              return ChatUser.fromJSON(_data);
            },
          ).toList();
          notifyListeners();
        },
      );
    } catch (e) {
      print("Error getting users.");
      print(e);
    }
  }

  void updateSelectedUsers(ChatUser _user) {
    if (_selectedUsers.contains(_user)) {
      _selectedUsers.remove(_user);
    } else {
      _selectedUsers.add(_user);
    }
    notifyListeners();
  }

  void createChat({List<Chat>? chats}) async {
    try {
      List<String> _membersIds =
          _selectedUsers.map((_user) => _user.uid).toList();
      _membersIds.add(_auth.user.uid);
      bool _isGroupChat = _selectedUsers.length > 1;
      List<ChatUser> _members = [];
      for (var _uid in _membersIds) {
        DocumentSnapshot _userSnapshot = await _db.getUser(_uid);
        Map<String, dynamic> _userData =
            _userSnapshot.data() as Map<String, dynamic>;
        _userData["uid"] = _userSnapshot.id;
        _members.add(
          ChatUser.fromJSON(_userData),
        );
      }

      Chat? _chatInstance;

      if (_members.length == 2) {
        List<String> membersUIDs = [];
        for (var _member in _members) {
          membersUIDs.add(_member.uid);
        }
        membersUIDs.sort();
        if (chats != null) {
          if (chats.isNotEmpty) {
            for (Chat chat in chats) {
              if (chat.members.length == _members.length) {
                List<String> uids = [];
                for (var _member in chat.members) {
                  uids.add(_member.uid);
                }
                uids.sort();
                if (ListEquality().equals(membersUIDs, uids)) {
                  _chatInstance = chat;
                }
              }
            }
          }
        }
      }
      if (_chatInstance == null) {
        DocumentReference? _doc = await _db.createChat({
          "is_group": _isGroupChat,
          "is_activity": false,
          "members": _membersIds,
        });
        _chatInstance = Chat(
            uid: _doc!.id,
            currentUserUid: _auth.user.uid,
            members: _members,
            messages: [],
            activity: false,
            group: _isGroupChat);
      }
      ChatPage _chatPage = ChatPage(chat: _chatInstance);
      _selectedUsers = [];
      notifyListeners();
      _navigation.navigateToPage(_chatPage);
    } catch (e) {
      print("Error creating chat.");
      print(e);
    }
  }
}
