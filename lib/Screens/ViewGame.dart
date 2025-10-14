import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart' as chess;


class ViewGamePage extends StatefulWidget {
  final String gameString;
  final chess.ChessBoardController controller;

  const ViewGamePage({super.key, required this.gameString, required this.controller});

  @override
  State<ViewGamePage> createState() => _ViewGamePageState();
}

class _ViewGamePageState extends State<ViewGamePage> {
  late final controller = widget.controller;

  List<List<String>> moves = [];
  List<List<String>> fenHistory = [];
  int currentTurn = 0;
  int color = 0;

  void extractMovesFromPGN(String pgn){
    final chessPackage = chess.Chess();

    // Let the chess package handle all the parsing.
    final success = chessPackage.load_pgn(pgn);
    if (!success) {
      throw Exception("Invalid PGN string");
    }

    // Retrieve all moves in order.
    final history = chessPackage.san_moves();

    for (String? move in history) {
      if(move != null){
        final info = move.split(" ");
        moves.add(info.sublist(1));
        fenHistory.add(["", ""]);
      }
    }

    print(moves);
  }

  void performNextMove(){
    if (currentTurn < moves.length - 1 || (currentTurn == moves.length - 1 && color < moves[currentTurn].length)){
      fenHistory[currentTurn][color] = controller.getFen(); // Get current position before
      controller.makeMoveWithNormalNotation(moves[currentTurn][color]);

      if(color == 1 && currentTurn < moves.length){
        color = 0;
        currentTurn += 1;
      } else {
        color = 1;
      }

      //print("here $fenHistory");
    } else {
      print("End of game.");
    }
  }

  void undoMove(){
    if(color == 0 && currentTurn > 0){
      color = 1;
      currentTurn -= 1;
    } else {
      color = 0;
    }

    if(currentTurn != -1){
      print("Turn: $currentTurn, Color: $color");


      print(fenHistory[currentTurn][color]);
      controller.loadFen(fenHistory[currentTurn][color]);
    } else {
      print("Beginning of game.");
    }
  }

  @override
  void initState() {
    super.initState();
    extractMovesFromPGN(widget.gameString);
    print(moves);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            chess.ChessBoard(
              controller: controller,
              boardOrientation: chess.PlayerColor.white,
            ),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () => undoMove(), child: Icon(Icons.arrow_left)),
                  ElevatedButton(onPressed: () => performNextMove(), child: Icon(Icons.arrow_right))
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Text(widget.gameString)
                ],
              ),
            ),
            SizedBox(height: 20,)
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
