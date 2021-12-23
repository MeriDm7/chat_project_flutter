import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:chat/services/database_service.dart';
import 'package:chat/services/cloud_strorage_service.dart';
import 'package:chat/services/media_service.dart';
import 'package:chat/services/navigation_service.dart';

import 'package:chat/providers/authentication_provider.dart';

import 'package:chat/models/chat_message.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudStorageService _storage;
  late MediaService _media;
  late NavigationService _navigation;

  AuthenticationProvider _auth;
  ScrollController _messagesViewController;

  String _chatId;
  List<ChatMessage>? messages;

  String? _message;

  String get message {
    return message;
  }

  ChatPageProvider(this._chatId, this._auth, this._messagesViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void goBack() {
    _navigation.goBack();
  }
}
