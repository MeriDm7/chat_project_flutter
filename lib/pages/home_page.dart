import 'package:flutter/material.dart';
import 'chats_page.dart';
import 'users_page.dart';

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
    const ChatsPage(),
    const UsersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        selectedItemColor: Colors.white,
        onTap: (_index) {
          setState(() {
            _currentPage = _index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              label: "", icon: Icon(Icons.chat_bubble_sharp)),
          BottomNavigationBarItem(
              label: "", icon: Icon(Icons.chat_bubble_sharp)),
        ],
      ),
    );
  }
}
