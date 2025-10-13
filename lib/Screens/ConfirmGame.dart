import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart' as chess;

class ConfirmGamePage extends StatefulWidget {
  final String gameString;

  const ConfirmGamePage({super.key, required this.gameString});

  @override
  State<ConfirmGamePage> createState() => _ConfirmGamePageState();
}

class _ConfirmGamePageState extends State<ConfirmGamePage> {
  final controller = chess.ChessBoardController();

  @override
  void initState() {
    super.initState();
    print("Given chess game string:\n${widget.gameString}");
    controller.loadPGN(widget.gameString);
    controller.loadFen(widget.gameString);
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
            Text("Is this final position correct?"),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("No")),
                  ElevatedButton(onPressed: () {}, child: Text("Yes"))
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
