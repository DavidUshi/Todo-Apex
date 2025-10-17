import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/add_screen.dart';
import 'package:flutter_application_2/screens/login_in.dart';
import 'package:flutter_application_2/screens/navigate_pages.dart';
import 'package:flutter_application_2/screens/today_screen.dart';
import 'package:flutter_application_2/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'providers/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()..init()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Todo App',
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.deepOrange,
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.grey[50],
              appBarTheme: const AppBarTheme(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(205, 255, 86, 34),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.deepOrange,
                unselectedItemColor: Colors.black54,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.deepOrange,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.grey[900],
              appBarTheme: const AppBarTheme(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(205, 255, 86, 34),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Colors.grey[850],
                selectedItemColor: Colors.deepOrange,
                unselectedItemColor: Colors.white70,
              ),
            ),
            themeMode: themeProvider.themeMode,
            home: const LoginPage(),
            routes: {
              '/homepage': (context) => const HomeScreen(),
              '/add': (context) => const AddScreen(),
              '/today': (context) => const Today(),
              '/first_page': (context) => const FirstPage(),
              '/auth': (context) => const LoginPage(),
            },
          );
        },
      ),
    );
  }
}
