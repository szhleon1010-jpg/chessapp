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

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(
      )
    );
  }
}

