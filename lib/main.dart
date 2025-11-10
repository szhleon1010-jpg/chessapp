import 'package:chessapp/Screens/Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff0b0a0a),
            foregroundColor: Colors.white
          )
        ),
        textTheme: TextTheme(
          titleMedium: TextStyle(
            color:Colors.white
          ),
            headlineSmall: TextStyle(
                color:Colors.white
            ),
          bodyMedium: TextStyle(
            color:Colors.white
          )
        ),

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black38),
      ),
      home: HomeScreen(
      )
    );
  }
}

