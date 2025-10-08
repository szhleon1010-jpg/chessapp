import 'package:chessapp/Screens/SavedGAmePage.dart';
import 'package:chessapp/Screens/ProfilePage.dart';
import 'package:chessapp/Screens/Analyzepage.dart';
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
    "Analyze New Game",
    "Saved Games",
    "Profile",
  ];
  int selectedScreen = 0;

  void onBarPressed(int index){
    setState(() {
      selectedScreen = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon:Icon (Icons.upload),label: "Analyze New Game"),
            BottomNavigationBarItem(icon:Icon (Icons.file_copy),label: "Saved Games"),
            BottomNavigationBarItem(icon:Icon (Icons.person_2_rounded),label: "Profile")
          ],
        currentIndex: selectedScreen,
        onTap: onBarPressed,
      ),
      backgroundColor: Color(0xff0b0a0a),
      appBar: AppBar(
        backgroundColor: Color(0xff171515),
        title: Text(
          style: TextStyle(
            color: Colors.white
          ),
          titles[selectedScreen]
        )
      ),
      body: screens[selectedScreen ],
    );
  }
}
