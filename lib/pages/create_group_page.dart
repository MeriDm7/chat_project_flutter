import 'package:chat/models/chat.dart';
import 'package:chat/models/chat_user.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/providers/chats_page_provider.dart';
import 'package:chat/providers/users_page_provider.dart';
import 'package:chat/services/cloud_strorage_service.dart';
import 'package:chat/services/database_service.dart';
import 'package:chat/services/media_service.dart';
import 'package:chat/services/navigation_service.dart';
import 'package:chat/widgets/custom_colors.dart';
import 'package:chat/widgets/custom_input_fields.dart';
import 'package:chat/widgets/custom_list_view_tiles.dart';
import 'package:chat/widgets/gradient_button.dart';
import 'package:chat/widgets/gradient_text.dart';
import 'package:chat/widgets/rounded_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:chat/providers/authentication_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class CreateGoupPage extends StatefulWidget {
  final List<ChatUser> members;

  CreateGoupPage({required this.members});

  @override
  State<StatefulWidget> createState() {
    return _CreateGroupPageState();
  }
}

class _CreateGroupPageState extends State<CreateGoupPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloudStorage;
  late NavigationService _navigation;

  PlatformFile? _groupImage;
  late UsersPageProvider _pageProvider;
  late ChatsPageProvider _chatsProvider;

  final _groupCreatingFormKey = GlobalKey<FormState>();

  String? _groupName;
  String? _imageURL;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorage = GetIt.instance.get<CloudStorageService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            stops: [0.1, 0.3, 0.6],
            colors: [neored, darkpurple, newblue],
            center: Alignment(0.6, -0.3),
            focal: Alignment(0.3, -0.1),
            focalRadius: 1.2,
          ),
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _topBar(),
            SizedBox(
              height: _deviceHeight * 0.03,
              width: _deviceWidth * 0.7,
            ),
            _groupImageField(),
            SizedBox(
              height: _deviceHeight * 0.05,
              width: _deviceWidth * 0.7,
            ),
            _groupNameForm(),
            SizedBox(
              height: _deviceHeight * 0.01,
              width: _deviceWidth * 0.6,
            ),
            _membersList(),
            SizedBox(
              height: _deviceHeight * 0.07,
            ),
            _createChatButton(),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Container(
        child: Row(children: [
      IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          _navigation.goBack();
        },
      ),
      GradientText(
        'New Group',
        style: const TextStyle(fontSize: 40, fontFamily: "it"),
        gradient: LinearGradient(colors: [Colors.white, neored, neopink]),
      )
    ]));
  }

  Widget _groupImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then(
          (_file) {
            setState(
              () {
                _groupImage = _file;
              },
            );
          },
        );
      },
      child: () {
        if (_groupImage != null) {
          return RoundedImageFile(
            key: UniqueKey(),
            image: _groupImage!,
            size: _deviceHeight * 0.03,
          );
        } else {
          return RoundedImageNetwork(
            key: UniqueKey(),
            imagePath:
                "https://www.gannett-cdn.com/presto/2018/12/13/PCIN/8da14ba2-bf12-4eac-b518-03ec7f24264b-Santa_Glamour_MV_023.JPG?width=660&height=441&fit=crop&format=pjpg&auto=webp",
            size: _deviceHeight * 0.10,
          );
        }
      }(),
    );
  }

  Widget _groupNameForm() {
    return Container(
      height: _deviceHeight * 0.2,
      width: _deviceWidth * 0.5,
      child: Form(
        key: _groupCreatingFormKey,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _createChatForm(),
            ]),
      ),
    );
  }

  Widget _membersList() {
    return Container(
      height: _deviceHeight * 0.25,
      child: ListView.builder(
        itemCount: widget.members.length,
        itemBuilder: (BuildContext _context, int _index) {
          return CustomGroupMembersViewTile(
              height: _deviceHeight * 0.05,
              title: widget.members[_index].name,
              imagePath: widget.members[_index].imageURL,
              isActive: widget.members[_index].wasRecentlyActive(),
              onTap: () {});
        },
      ),
    );
  }

  Widget _createChatForm() {
    return SizedBox(
        height: _deviceHeight * 0.07,
        child: CustomTextFormField(
            onSaved: (_value) {
              setState(() {
                _groupName = _value;
              });
            },
            regEx: r'.{2,}',
            hintText: "Group Name",
            validationText: "Minimum 2 characters",
            obscureText: false));
  }

  Widget _createChatButton() {
    return GradientButton(
        name: "Create Chat",
        onPressed: () async {
          if (_groupCreatingFormKey.currentState!.validate()) {
            _groupCreatingFormKey.currentState!.save();
            print("NAMEEEE: " + _groupName!);
            if (_groupImage == null) {
              _imageURL =
                  "https://www.gannett-cdn.com/presto/2018/12/13/PCIN/8da14ba2-bf12-4eac-b518-03ec7f24264b-Santa_Glamour_MV_023.JPG?width=660&height=441&fit=crop&format=pjpg&auto=webp";
            } else {
              _imageURL = await _cloudStorage.saveGroupImageToStorage(
                  _groupName!, _auth.user.uid, _groupImage!);
            }
            List<String> membersIds = [];
            for (var element in widget.members) {
              membersIds.add(element.uid);
            }
            DocumentReference? _doc = await _db.createChat({
              "is_group": true,
              "group_name": _groupName,
              "group_image": _imageURL,
              "is_activity": false,
              "members": membersIds
            });

            Chat _chatInstance = Chat(_groupName, _imageURL,
                uid: _doc!.id,
                currentUserUid: _auth.user.uid,
                members: widget.members,
                messages: [],
                activity: false,
                group: true);
            ChatPage _chatPage = ChatPage(chat: _chatInstance);
            _navigation.navigateToPage(_chatPage);
          }
        });
  }
}
