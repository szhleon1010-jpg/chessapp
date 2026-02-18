import 'package:chessapp/Screens/EditGamePage.dart';
import 'package:chessapp/Screens/ViewGame.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart' as chess;

import '../Services/Firebase_utils.dart';

class ConfirmGamePage extends StatefulWidget {
  final String gameString;
  final String whiteName;
  final String whiteElo;
  final String blackName;
  final String blackElo;
  final String event;
  final String location;
  final String isPlayer;
  final Timestamp date;
  final String gameId;
  const ConfirmGamePage({super.key,
    required this.gameString,
    this.whiteName = "",
    this.whiteElo = "1200",
    this.blackName = "",
    this.blackElo = "1200",
    this.event = "",
    this.location = "",
    this.isPlayer = "Neither",
    this.gameId = "",
    required this.date
  });
  @override
  State<ConfirmGamePage> createState() => _ConfirmGamePageState();
}

class _ConfirmGamePageState extends State<ConfirmGamePage> {
  final controller = chess.ChessBoardController();
  List <String?> PGNstring = [];
  late Map <String, dynamic> gameInfo ;
  void updateGameInfo(Map <String, dynamic> newGameInfo)async{
    controller.loadPGN(newGameInfo["gameStr"]);
    List <String?> tempGame = controller.getSan();
    if(tempGame.length!=PGNstring.length){
      if(!(await confirmEdits())){
        controller.loadPGN(gameInfo["gameStr"]);
        return;
      }
    }
    setState(() {
     gameInfo = newGameInfo;
     controller.loadPGN(gameInfo["gameStr"]);
     PGNstring = controller.getSan();
     gameInfo["gameStr"] = PGNstring.join(" ");
     print(gameInfo);
   });
  }
  Future<bool> confirmEdits()async{
    bool confirm = false;
    await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Are you sure you want to save these changes?"),
            content: Text("The moves may be shortened to maintain a legal game."),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel")),
              TextButton(onPressed: (){
                confirm = true;
                Navigator.pop(context);
              }, child: Text("Confirm"))
            ],
          );
        }
    );
    return confirm;
  }

  void showSaveDialog() async {
    bool loading = false;

    showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: Color(0xff393838),
        title: Text("Save Game to Library"),
        content: SizedBox(
          height: 75,
          child: Column(
            children: [
              Text("Do you want to save this game to your library?"),
              (loading) ? CircularProgressIndicator() : Container()
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(onPressed: () async {
            loading = true;
            bool result = await FirebaseUtils.AddGame(gameInfo);
            if(result){
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Game successfully saved!", style: TextStyle(color: Colors.white),)));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Game failed to save. Please try again.", style: TextStyle(color: Colors.white),)));
            }
            loading = false;
          }, child: Text("Save"))
        ],
      );
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
      "date": widget.date,
      "gameStr": widget.gameString,
      "isPlayer" : widget.isPlayer,
      "gameId" : widget.gameId
    };
    controller.loadPGN(gameInfo["gameStr"]);
    PGNstring = controller.getSan();
    gameInfo["gameStr"] = PGNstring.join(" ");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            chess.ChessBoard(controller: controller, enableUserMoves: false,),
            Text("Is this final position correct?", style: TextStyle(fontSize: 20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              ElevatedButton(onPressed: ()=>Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_)=>EditGamePage(
                        moves: PGNstring, gameInfo: gameInfo, updateGameInfo: updateGameInfo,))), child: Text("Edit Game")),
              ElevatedButton(onPressed: (){
                controller.resetBoard();
                Navigator.pop(context);
                Navigator.push(context,MaterialPageRoute(builder: (_)=>
                ViewGamePage(gameString: gameInfo["gameStr"], controller: controller, gameInfo: gameInfo,))
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
          ],
        ),
      ),
      backgroundColor: Color(0xff0b0a0a),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff171515),
        title: Text("Confirm Game?"),
        actions: [
          IconButton(onPressed: (){
            showSaveDialog();
          }, icon: Icon(Icons.save_alt_rounded))
        ],
      ),
    );
  }
}