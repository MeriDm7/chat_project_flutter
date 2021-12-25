import 'package:chat/pages/personal_page.dart';
import 'package:flutter/material.dart';
import 'chats_page.dart';
import '../pages/users_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final List<Widget> _pages = [
    ChatsPage(),
    UsersPage(),
    PersonalPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Color.fromRGBO(255, 255, 255, 0.1),

        currentIndex: _currentPage,
        selectedItemColor: Colors.white,
        onTap: (_index) {
          setState(() {
            _currentPage = _index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              label: "",
              icon: Icon(
                Icons.chat_bubble_sharp,
                size: 30,
              )),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Icons.supervised_user_circle_outlined,
              size: 36,
            ),
          ),
          BottomNavigationBarItem(
              label: "",
              icon: Icon(
                Icons.settings_applications_outlined,
                size: 36,
              )),
        ],
      ),
    );
  }
}
