import 'dart:convert';
import 'package:chessapp/Services/Firebase_utils.dart';
import 'package:chessapp/widgets/eval%20bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart' as chess;
import 'package:http/http.dart' as http;
import 'package:stockfish/stockfish.dart';

enum moveGrade{
  blunder,
  mistake,
  inaccuracy,
  none,
  book,
  good,
  excellent,
  best,
  brilliant
}
class ViewGamePage extends StatefulWidget {
  final String gameString;
  final Map<String, dynamic> gameInfo;
  final chess.ChessBoardController controller;
  const ViewGamePage({super.key,required this. gameString, required this.controller, required this.gameInfo});

  @override
  State<ViewGamePage> createState() => _ViewGamePageState();
}

class _ViewGamePageState extends State<ViewGamePage> {
  late final controller = widget.controller;
  final stockfish = Stockfish();

  //settings
  int depth = 10;
  bool showLines = true;
  bool enableArrows = true;
  chess.BoardColor boardColor = chess.BoardColor.brown;
  chess.PlayerColor SwitchSide = chess.PlayerColor.white;

  void openSettingBox ()async{
    await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Board Settings"),
            backgroundColor: Color(0xff393838),
            content: StatefulBuilder(
                builder: (context, StateSetter setState){
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Depth"),
                          DropdownButton <int> (
                              value: depth ,
                              dropdownColor: Color(0xff393838),
                              items:
                              List.generate(26, (num){
                                return DropdownMenuItem(child: Text((num + 5).toString()),value: num + 5,);
                              })
                              , onChanged: (int? value){
                            setState(() {
                              depth = value!;
                            });
                          })
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Board Color"),
                          DropdownButton <chess.BoardColor> (
                              value: boardColor ,
                              dropdownColor: Color(0xff393838),
                              items:
                              [
                                DropdownMenuItem(child: Text("Brown",),value: chess.BoardColor.brown,),
                                DropdownMenuItem(child: Text("Dark brown",),value: chess.BoardColor.darkBrown,),
                                DropdownMenuItem(child: Text("Green",),value: chess.BoardColor.green,),
                                DropdownMenuItem(child: Text("Orange",),value: chess.BoardColor.orange,)
                              ]
                              , onChanged: (chess.BoardColor? value){
                            setState(() {
                              boardColor = value!;
                            });
                          })
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Player Color"),
                          DropdownButton <chess.PlayerColor> (
                              value: SwitchSide ,
                              dropdownColor: Color(0xff393838),
                              items:
                              [
                                DropdownMenuItem(child: Text("White",),value: chess.PlayerColor.white,),
                                DropdownMenuItem(child: Text("Black",),value: chess.PlayerColor.black),

                              ]
                              , onChanged: (chess.PlayerColor? value){
                            setState(() {
                              SwitchSide = value!;
                            });
                          })
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Show Lines"),
                          CupertinoSwitch(value: showLines, onChanged: (bool value){
                            setState(() {
                              showLines = value;
                            });
                          })
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Show Arrows"),
                          CupertinoSwitch(value: enableArrows, onChanged: (bool value){
                            setState(() {
                              enableArrows = value;
                            });
                          })
                        ],
                      )
                    ],
                  );
                }
            ),
          );
        }
    ).then((dynamic result){
      setState(() {

      });
    });
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
            bool result = await FirebaseUtils.AddGame(widget.gameInfo);
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

  String BestMove = "";
  bool isLoading = true;
  List<String> Moves = [];
  String Opening = "Starting Position";
  List<chess.BoardArrow> bestMoveArrow = [];
  List<String> History = [];

  List<String> BestLines = [];
  List<String> BestlineScore = [];
  int currentMove = 0;
  int score = 0;
  bool mate = false;
  moveGrade lastMoveGrade = moveGrade.none;
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
  Future <void> getopening()async {
    final FENBoard = controller.getFen();
    final encodeFen = Uri.encodeFull(FENBoard);
    final URL = Uri.parse("https://explorer.lichess.ovh/masters?fen=$encodeFen");
    final response = await http.get(URL);
    if(response.statusCode!= 200){
      throw Exception("Failed to get opening");
    }
    final data = json.decode(response.body);
    final opening = data["opening"];
    setState(() {
      if(opening != null){
        Opening = opening["name"];
      }
    });
  }
  void doMoveInLine (String piece, String moveTo){
    controller.makeMove(from: piece, to: moveTo);
  }

  void doNextMove(bool calculate) {
    if (currentMove < Moves.length) {
      setState(() {
        isLoading = true;
      });
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
        stockfish.stdin = 'stop';
        stockfish.stdin = 'position fen ${controller.getFen()}';
        stockfish.stdin = 'go depth $depth';
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
    stockfish.stdin = 'stop';
    stockfish.stdin = 'position fen ${controller.getFen()}';
    stockfish.stdin = 'go depth $depth';
    setState(() {
      currentMove = index + 1;
    });
  }
  void undoMove() {
    if (currentMove > 0) {
      setState(() {
        currentMove -= 1;
      });
      controller.loadFen(History[currentMove]);
      stockfish.stdin = 'stop';
      stockfish.stdin = 'position fen ${controller.getFen()}';
      stockfish.stdin = 'go depth $depth';
    }
  }
  Future<void> initializeStockfish() async {
    while (stockfish.state.value != StockfishState.ready) {
      await Future.delayed(Duration(milliseconds: 100));
      print(stockfish.state.value);
    }

    stockfish.stdout.listen((event) {
      print(event);
      if (event.startsWith("bestmove")) {
        final moves = event.split(" ");
        final best = moves[1];
        final fromPiece = best.substring(0, 2);
        final toPiece = best.substring(2, 4);
        getopening();
        setState(() {
          bestMoveArrow.clear();
          bestMoveArrow.add(chess.BoardArrow(
              from: fromPiece, to: toPiece, color: Color(0xffbfc51b)));
          BestMove = best;
          isLoading = false;
        });
      } else if (event.startsWith("info depth")) {
        int infoDepth = int.parse(event.substring(11, event.indexOf(' seldepth')));
        if (infoDepth >= 5) {
          final pvIndex = event.indexOf(' pv');
          if (pvIndex == -1) return;
          final lineString = event.substring(pvIndex + 4);
          final beforeScore = score;

          // Handle both centipawn and mate scores
          if (event.contains(' mate ')) {
            final mateIndex = event.indexOf(' mate ') + 6;
            final mateEnd = event.indexOf(' ', mateIndex);
            final mateValue = int.parse(event.substring(mateIndex, mateEnd));
            mate = true;
            score = mateValue > 0 ? 10000 : -10000;
            BestLines.add(lineString);
            BestlineScore.add('mate $mateValue');
          } else if (event.contains(' cp ')) {
            final cpIndex = event.indexOf(' cp ') + 4;
            final cpEnd = event.indexOf(' ', cpIndex);
            final cpValue = int.parse(event.substring(cpIndex, cpEnd));
            mate = false;
            score = cpValue;
            BestLines.add(lineString);
            BestlineScore.add(cpValue.toString());
          }

          setState(() {
            final d = beforeScore - score;
            if (d > 200) {
              lastMoveGrade = moveGrade.blunder;
            } else if (d > 150) {
              lastMoveGrade = moveGrade.mistake;
            } else if (d > 70) {
              lastMoveGrade = moveGrade.inaccuracy;
            } else if (d > 30) {
              lastMoveGrade = moveGrade.good;
            } else if (d > 1) {
              lastMoveGrade = moveGrade.excellent;
            } else if (d <= 1) {
              lastMoveGrade = moveGrade.best;
            }
          });
        }
      } else {
        setState(() {
          isLoading = true;
          BestLines = [];
          BestlineScore = [];
        });
      }
    });

    // Proper UCI initialization sequence
    stockfish.stdin = 'uci';
    await Future.delayed(Duration(milliseconds: 50));
    stockfish.stdin = 'setoption name MultiPV value ${showLines ? 3 : 1}';
    stockfish.stdin = 'isready';
    await Future.delayed(Duration(milliseconds: 50));
    stockfish.stdin = 'position startpos';
    stockfish.stdin = 'go depth $depth';
  }
  @override
  void initState(){
    super.initState();
    extractMovesFromPGN(widget.gameString);
    initializeStockfish();
    controller.addListener((){
      if (!isLoading) {
        stockfish.stdin = 'stop';
        stockfish.stdin = 'position fen ${controller.getFen()}';
        stockfish.stdin = 'go depth $depth';
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 380,
              child: Row(
                children: [
                  EvalBar(score: score, mate: mate,),
                  chess.ChessBoard(
                    controller: widget.controller,
                    arrows: (enableArrows)?bestMoveArrow: [],
                    boardColor: boardColor,
                    boardOrientation: SwitchSide,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    width: 150,
                    child: Text(Opening, style: TextStyle(color: Colors.white),)),
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
            Text(lastMoveGrade.toString()),
            SizedBox(
              height: 80,
              child: (!isLoading&&showLines)?SingleChildScrollView(
                child: Column(
                  children: [
                    RichText(
                        text: TextSpan(
                          text: "${ ((int.parse(BestlineScore[0])>0)?"+":"-")}${int.parse(BestlineScore[0]) /100.0} ",
                          style: TextStyle(
                              color: ((int.parse(BestlineScore[0])>0)?Colors.black:Colors.white),
                              backgroundColor: ((int.parse(BestlineScore[0])>0)?Colors.white:Colors.black)
                          ),
                          children: BestLines[0].split(" ").asMap().entries.map((entry) {
                            final index = entry.key;
                            final move = entry.value;

                            final turnNumber = (index ~/ 2) + 1;

                            return TextSpan(
                                text: "${(index % 2 == 0) ? '$turnNumber.' : ''} $move ",
                                style: TextStyle(
                                  color: index == currentMove - 1 ? Colors.green : ((int.parse(BestlineScore[0])>0)?Colors.black:Colors.white),
                                  fontWeight: index == currentMove - 1 ? FontWeight.bold : FontWeight.normal,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => doMoveInLine(move.substring(0,2), move.substring(2,4))
                            );
                          }).toList(),
                        )
                    ),
                    RichText(
                        text: TextSpan(
                          text: "${ ((int.parse(BestlineScore[1])>0)?"+":"-")}${int.parse(BestlineScore[1]) /100.0} ",
                          style: TextStyle(
                              color: ((int.parse(BestlineScore[1])>0)?Colors.black:Colors.white),
                              backgroundColor: ((int.parse(BestlineScore[1])>0)?Colors.white:Colors.black)
                          ),
                          children: BestLines[1].split(" ").asMap().entries.map((entry) {
                            final index = entry.key;
                            final move = entry.value;

                            final turnNumber = (index ~/ 2) + 1;

                            return TextSpan(
                                text: "${(index % 2 == 0) ? '$turnNumber.' : ''} $move ",
                                style: TextStyle(
                                  color: index == currentMove - 1 ? Colors.green : ((int.parse(BestlineScore[1])>0)?Colors.black:Colors.white),
                                  fontWeight: index == currentMove - 1 ? FontWeight.bold : FontWeight.normal,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => doMoveInLine(move.substring(0,2), move.substring(2,4))
                            );
                          }).toList(),
                        )
                    ),
                    RichText(
                        text: TextSpan(
                          text: "${ ((int.parse(BestlineScore[2])>0)?"+":"-")}${int.parse(BestlineScore[2]) /100.0} ",
                          style: TextStyle(
                              color: ((int.parse(BestlineScore[2])>0)?Colors.black:Colors.white),
                              backgroundColor: ((int.parse(BestlineScore[2])>0)?Colors.white:Colors.black)
                          ),
                          children: BestLines[2].split(" ").asMap().entries.map((entry) {
                            final index = entry.key;
                            final move = entry.value;
                            final turnNumber = (index ~/ 2) + 1;
                            return TextSpan(
                                text: "${(index % 2 == 0) ? '$turnNumber.' : ''} $move ",
                                style: TextStyle(
                                  color: index == currentMove - 1 ? Colors.green : ((int.parse(BestlineScore[2])>0)?Colors.black:Colors.white),
                                  fontWeight: index == currentMove - 1 ? FontWeight.bold : FontWeight.normal,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => doMoveInLine(move.substring(0,2), move.substring(2,4))
                            );
                          }).toList(),
                        )
                    ),
                  ],
                ),
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
        actions: [
          IconButton(onPressed: (){
            openSettingBox();
          }, icon: Icon(Icons.settings)),
          IconButton(onPressed: (){
            showSaveDialog();
          }, icon: Icon(Icons.save_alt_rounded))
        ],

      ),
    );
  }
  @override
  void dispose(){
    super.dispose();
    stockfish.dispose();
  }
}
