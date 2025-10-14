import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart' as chess;

class ViewGamePage extends StatefulWidget {
  final gameString;
  final controller;
  const ViewGamePage({super.key,required this. gameString, required this.controller});

  @override
  State<ViewGamePage> createState() => _ViewGamePageState();
}

class _ViewGamePageState extends State<ViewGamePage> {
  List<List<String>> Moves = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          children: [
            chess.ChessBoard(controller: widget.controller),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: ()=>{}, child: Icon(Icons.arrow_circle_left, size: 30,)),
                ElevatedButton(onPressed: (){}, child: Icon(Icons.arrow_circle_right, size: 30,))
              ],
            ),
            Text(widget.gameString)
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
