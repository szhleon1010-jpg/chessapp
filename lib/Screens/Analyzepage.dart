import 'package:chessapp/Screens/ViewGame.dart';
import 'package:chessapp/Screens/confirmPage.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final textcontroller = TextEditingController();
  String GameString= "";
  String cleanPGN(String pgn) {
    return pgn
    // Remove invisible or non-breaking spaces
        .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF\u00A0]'), '')
    // Remove comments in braces { ... }
        .replaceAll(RegExp(r'\{[^}]*\}'), '')
    // Remove ellipses
        .replaceAll('..', '')
    // Trim leading/trailing spaces
        .trim();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Upload Image ", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold
          ),),
          Text("Recording sheet of PGN or FEN"),
          Center(
              child: Container(
                padding: EdgeInsets.all(8), // Border width
                decoration: BoxDecoration( borderRadius: BorderRadius.circular(10000)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(100), // Image radius
                    child: Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/ChessSet.jpg/250px-ChessSet.jpg'
                        '', fit: BoxFit.cover),
                  ),
                ),
              )
          ),
          SizedBox(height: 50,),
          Text("Input PGN or FEN", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
          Text("Paste Chess Notation Below", style: TextStyle(fontSize: 18),),
          SizedBox(

              width: 300,
              child: TextField(
                onChanged:(str){
                  GameString = str;
                },
                controller: textcontroller,
                minLines: 5,
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true, fillColor: Color(0xff2c2c2c)
                ),
                style: TextStyle(color: Colors.white),
            )
          ),
          SizedBox(height: 50,),
          ElevatedButton
            (onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>ConfirmGamePage(gameString:cleanPGN(GameString))));
          },
              child: Text("Analyze"),
        )
        ]
      ),
    );
  }
}
