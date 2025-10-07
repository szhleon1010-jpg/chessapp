import 'package:chessapp/Screens/AnalyzePage.dart' show AnalyzePage;
import 'package:chessapp/Screens/UploadPage.dart' show UploadPage;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String welcomeMessage = "Welcome";
  void changewelcomeMessage(){
    setState(() {
      if(  welcomeMessage == "hi"){
        welcomeMessage = "Welcome";
      }else{
        welcomeMessage = "hi";
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [

          Container(
            width: 600,
            margin: EdgeInsets.only(left:18),
            child: Text(
                textAlign: TextAlign.start,
                welcomeMessage
            ),
          ),
          Center(child: ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>AnalyzePage()));
          }, child:Text("Analyze Game") )),
          Center(child: ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>UploadPage()));
          }, child:Text("Upload Your Game") ))
        ]
    );
  }
}
