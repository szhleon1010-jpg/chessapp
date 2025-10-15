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

  List<String> moves = [];
  List<String> fenHistory = [];
  int currentMove = 0;

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
        final currMoves = info.sublist(1);
        moves.addAll(currMoves);
        fenHistory.addAll(List.filled(currMoves.length, ""));
      }
    }

    print(moves);
    print(fenHistory);
  }

  void performNextMove(){
    if (currentMove < moves.length){
      fenHistory[currentMove] = controller.getFen(); // Get current position before
      controller.makeMoveWithNormalNotation(moves[currentMove]);

      setState(() {
        currentMove += 1;
      });

    } else {
      print("End of game.");
    }
  }

  void undoMove(){
    if(currentMove > 0){
      setState(() {
        currentMove -= 1;
      });
    } else {
      print("Beginning of game.");
      return;
    }

    controller.loadFen(fenHistory[currentMove]);
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
              child: RichText(
                text: TextSpan(
                  children: moves.asMap().entries.map((entry) {
                    final index = entry.key;
                    final move = entry.value;

                    final turnNumber = (index ~/ 2) + 1;

                    return TextSpan(
                      text: "${(index % 2 == 0) ? '$turnNumber.' : ''} $move ",
                      style: TextStyle(
                        color: index == currentMove - 1 ? Colors.green : Colors.white,
                        fontWeight: index == currentMove - 1 ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                )
              )
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

  @override
  void dispose() {
    super.dispose();
  }
}
