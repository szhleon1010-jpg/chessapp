import 'package:flutter/material.dart';

class ViewGamePage extends StatefulWidget {
  const ViewGamePage({super.key});

  @override
  State<ViewGamePage> createState() => _ViewGamePageState();
}

class _ViewGamePageState extends State<ViewGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ],
        ),
      ),
      backgroundColor: Color(0xff0b0a0a),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff171515),
        title: Text("View Game"),

      ),
    );
  }
}
