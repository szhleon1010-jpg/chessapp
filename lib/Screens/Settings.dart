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
        Text("Account", style: TextStyle(fontSize: 15),),
        Container(
          child: Column(
            children: [
              Container(
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
                          Text("Logout"),
                          Text("Sign out of your account")
                        ],
                      )
                    ),
                    Icon(Icons.chevron_right, color: Colors.white,)
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
