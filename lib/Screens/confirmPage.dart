import 'package:chessapp/Screens/EditGamePage.dart';
import 'package:chessapp/Screens/ViewGame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart' as chess;

class ConfirmGamePage extends StatefulWidget {
  final String gameString;
  final String whiteName;
  final String blackName;
  final String event;
  final String location;
  const ConfirmGamePage({super.key,
    required this.gameString,
    this.whiteName = "",
    this.blackName = "",
    this.event = "",
    this.location = "",
  });
  @override
  State<ConfirmGamePage> createState() => _ConfirmGamePageState();
}

class _ConfirmGamePageState extends State<ConfirmGamePage> {
  final controller = chess.ChessBoardController();
  List <String?> PGNstring = [];

  @override
  void initState(){
    super.initState();
    controller.loadPGN(widget.gameString);
    PGNstring = controller.getSan();
    print(PGNstring);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          children: [
            chess.ChessBoard(controller: controller),
            Text("Is this final position correct?", style: TextStyle(fontSize: 20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text("No")),
              ElevatedButton(onPressed: (){
                controller.resetBoard();
                Navigator.pop(context);
                Navigator.push(context,MaterialPageRoute(builder: (_)=>
                ViewGamePage(gameString: widget.gameString, controller: controller))
                );
              }, child: Text("Yes"))
            ],
            ),
            Expanded(
              child: ListView(
                children: [
                  Text(widget.gameString),
                ],
              ),
            ),
            ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>EditGamePage(moves: PGNstring,))), child: Text("Edit game")),
          ],
        ),
      ),
      backgroundColor: Color(0xff0b0a0a),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff171515),
        title: Text("Confirm Game?"),
      ),
    );
  }
}