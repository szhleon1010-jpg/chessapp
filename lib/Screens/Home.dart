import 'package:chessapp/Screens/AnalyzePage.dart';
import 'package:chessapp/Screens/ProfilePage.dart';
import 'package:chessapp/Screens/UploadPage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Widget> screens = [
    UploadPage(),
    AnalyzePage(),
    ProfilePage()
  ];
  List<String> titles = [
    "Upload Game",
    "Analysis",
    "Profile",
  ];
  int selectedscreen = 0;

  void onBarPressed(int index){
    setState(() {
      selectedscreen = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon:Icon (Icons.upload),label: "Upload Game"),
            BottomNavigationBarItem(icon:Icon (Icons.compass_calibration),label: "Analysis"),
            BottomNavigationBarItem(icon:Icon (Icons.person_2_rounded),label: "Profile")
          ],
        currentIndex: selectedscreen,
        onTap: onBarPressed,
      ),
      backgroundColor: Color(0xff0b0a0a),
      appBar: AppBar(
        backgroundColor: Color(0xff171515),
        title: Text(
          style: TextStyle(
            color: Colors.white
          ),
          titles[selectedscreen]
        )
      ),
      body: screens[selectedscreen ],
    );
  }
}
