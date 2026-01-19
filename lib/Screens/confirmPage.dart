import 'package:chessapp/Screens/EditGamePage.dart';
import 'package:chessapp/Screens/ViewGame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart' as chess;

class ConfirmGamePage extends StatefulWidget {
  final String gameString;
  final String whiteName;
  final int whiteElo;
  final String blackName;
  final int blackElo;
  final String event;
  final String location;
  final String isPlayer;
  const ConfirmGamePage({super.key,
    required this.gameString,
    this.whiteName = "",
    this.whiteElo = 1200,
    this.blackName = "",
    this.blackElo = 1200,
    this.event = "",
    this.location = "",
    this.isPlayer = "Neither",
  });
  @override
  State<ConfirmGamePage> createState() => _ConfirmGamePageState();
}

class _ConfirmGamePageState extends State<ConfirmGamePage> {
  final controller = chess.ChessBoardController();
  List <String?> PGNstring = [];
  late Map <String, dynamic> gameInfo ;
  void updateGameInfo(Map <String, dynamic> newGameInfo){
   setState(() {
     gameInfo = newGameInfo;

   });
  }
  @override
  void initState(){
    super.initState();
    gameInfo = {
      "white": widget.whiteName,
      "whiteElo": widget.whiteElo,
      "black": widget.blackName,
      "blackElo": widget.blackElo,
      "event": widget.event,
      "location": widget.location,
      "date": DateTime.now(),
      "gameStr": widget.gameString,
      "isPlayer" : widget.isPlayer,
    };
    controller.loadPGN(gameInfo["gameStr"]);
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
                ViewGamePage(gameString: gameInfo["gameStr"], controller: controller))
                );
              }, child: Text("Yes"))
            ],
            ),
            Expanded(
              child: ListView(
                children: [
                  Text(gameInfo["gameStr"]),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: ()=>Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_)=>EditGamePage(
                          moves: PGNstring, gameInfo: gameInfo, updateGameInfo: updateGameInfo,))), child: Text("Edit game")),
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