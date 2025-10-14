import 'package:chessapp/Screens/Home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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

