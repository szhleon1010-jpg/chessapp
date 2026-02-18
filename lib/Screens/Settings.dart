import 'package:chessapp/Screens/Accounts/SignInPg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mainBackgroundColor,
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(color: Colors.white),),
        backgroundColor: Constants.appbarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            accountSection()
          ],
        ),
      ),
    );
  }
  Widget accountSection(){
    return Column(
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignInPage()));
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white)
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.logout, color: Colors.orange, size: 22),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text("Logout", style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 5,),
                          Text("Sign out of your account")
                        ],
                      )
                    ),
                    Icon(Icons.chevron_right, color: Colors.white,)
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
