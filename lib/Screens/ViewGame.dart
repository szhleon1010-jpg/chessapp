import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart' as chess;
import 'package:stockfish/stockfish.dart';

class ViewGamePage extends StatefulWidget {
  final String gameString;
  final chess.ChessBoardController controller;
  const ViewGamePage({super.key,required this. gameString, required this.controller});

  @override
  State<ViewGamePage> createState() => _ViewGamePageState();
}

class _ViewGamePageState extends State<ViewGamePage> {
  late final controller = widget.controller;
  final stockfish = Stockfish();
  String BestMove = "";
  bool isLoading = true;

  List<String> Moves = [];
  List<String> History = [];
  List<String> BestLines = [];
  int currentMove = 0;
  void  extractMovesFromPGN(String PGN){
    final chesspackage = chess.Chess();
    final success = chesspackage.load_pgn(PGN);
    if(!success){
      throw Exception("PGN invalid");
    }
    final Hist = chesspackage.san_moves();
    for(String? Move in Hist){
      if(Move != null){
        final info = Move.split(" ");
        final actualMoves = info.sublist(1);
        Moves.addAll(actualMoves);
        History.addAll(List.filled(actualMoves.length, ""));
      }
    }
    History.add("");
    print(Moves);
  }
  void doNextMove(bool calculate) {
    if (currentMove < Moves.length) {
      final FENBoard = controller.getFen();
      History[currentMove] = FENBoard;
      controller.makeMoveWithNormalNotation(Moves[currentMove]);
      setState(() {
        currentMove += 1;
      });
      if(currentMove == Moves.length){
        History[currentMove] = controller.getFen();
      }
      if (calculate) {
        stockfish.stdin = 'position fen ${controller.getFen()}';
        stockfish.stdin = 'go depth 8';
      }
    }
  
  }
  Future<void> jumptomove(int index)async{
    if(index + 1 < History.length&&History[index + 1] != ""){
      controller.loadFen(History[index + 1 ]);
    }
    else{
      for(int i = currentMove; i <= index; i++){
        doNextMove(false);
        await Future.delayed(Duration(microseconds: 100));
      }
    }
    stockfish.stdin = 'position fen ${controller.getFen()}';
    stockfish.stdin = 'go depth 8';
    setState(() {
      currentMove = index + 1 ;
    });
  }
  void undoMove(){
    if(currentMove > 0){
      setState(() {
        currentMove -= 1;
      });
      controller.loadFen(History[currentMove]);
      stockfish.stdin = 'position fen ${controller.getFen()}';
      stockfish.stdin = 'go depth 8';
    }
  }
  Future<void> initializestockfish()async{
    while(stockfish.state.value != StockfishState.ready){
      await Future.delayed(Duration(milliseconds: 100));
      print(stockfish.state.value);
    }
    stockfish.stdout.listen((event){
      print(event);
      if(event.startsWith("bestmove")){
        final moves = event.split(" ");
        final best = moves[1];
        setState(() {
          BestMove = best;
          isLoading = false;
        });
      }
      else if(event.startsWith("info depth 8")){
        final lineString = event.substring(event.indexOf(' pv')+4);
        BestLines.add(lineString);
      }
      else{
        setState(() {
          isLoading = true;
          BestLines = [];
        });
      }
    });
    stockfish.stdin = 'isready';
    stockfish.stdin = 'position startpos';
    stockfish.stdin = 'setoption name MultiPV value 3';
    stockfish.stdin = 'go depth 8';
  }
  @override
  void initState(){
    super.initState();
    extractMovesFromPGN(widget.gameString);
    initializestockfish();
    controller.addListener((){
      stockfish.stdin = 'position fen ${controller.getFen()}';
      stockfish.stdin = 'go depth 8';
    });
  }
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
                ElevatedButton(onPressed: ()=>undoMove(), child: Icon(Icons.arrow_circle_left, size: 30,)),
                ElevatedButton(onPressed: ()=> doNextMove(true), child: Icon(Icons.arrow_circle_right, size: 30,))
              ],
            ),
            Expanded(
                child: RichText(
                    text: TextSpan(
                      children: Moves.asMap().entries.map((entry) {
                        final index = entry.key;
                        final move = entry.value;

                        final turnNumber = (index ~/ 2) + 1;

                        return TextSpan(
                          text: "${(index % 2 == 0) ? '$turnNumber.' : ''} $move ",
                          style: TextStyle(
                            color: index == currentMove - 1 ? Colors.green : Colors.white,
                            fontWeight: index == currentMove - 1 ? FontWeight.bold : FontWeight.normal,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => jumptomove(index)
                        );
                      }).toList(),
                    )
                )
            ),
            SizedBox(
            height: 80,
            child: (!isLoading)?Column(
              children: [
                Text(BestLines[0]),
                Text(BestLines[1]),
                Text(BestLines[2]),
              ],
            ):SizedBox(),
          ),
          Text("Best Move:$BestMove"),
            SizedBox(
              height: 50,
              width: 50,
              child: (isLoading)?SizedBox(height: 50, child: CircularProgressIndicator()):SizedBox())
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
  void dispose(){
    super.dispose();
    stockfish.dispose();
  }
}
