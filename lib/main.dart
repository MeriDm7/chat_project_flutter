import 'package:chat/providers/authentication_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Packages
import 'package:provider/provider.dart';

// Services
import './services/navigation_service.dart';

// Pages
import './pages/splash_page.dart';
import './pages/login_page.dart';
import './pages/home_page.dart';
import './pages/register_page.dart';

// Providers
import './providers/authentication_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(
          MainApp(),
        );
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext _context) {
            return AuthenticationProvider();
          },
        )
      ],
      child: MaterialApp(
        title: 'Chat',
        theme: ThemeData(
          backgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
          scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
          ),
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext _context) => LoginPage(),
          '/register': (BuildContext _context) => RegisterPage(),
          '/home': (BuildContext _context) => HomePage(),
        },
      ),
    );
  }
}
