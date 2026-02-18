import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart' as chess;
import 'package:intl/intl.dart';

import '../Screens/confirmPage.dart';

class GameTile extends StatelessWidget {
  final String pgn;
  final String blackName;
  final String blackElo;
  final String whiteElo;
  final String whiteName;
  final Timestamp date;
  final String event;
  final String location;
  final String isPlayer;
  final String gameId;
  const GameTile({super.key, required this.pgn, required this.blackName, required this.blackElo, required this.whiteElo, required this.whiteName, required this.date, required this.event, required this.location, required this.isPlayer, required this.gameId});

  @override
  Widget build(BuildContext context) {
    final tempDate = date.toDate();
    final formatDate = DateFormat("MM/dd/yyyy").format(tempDate);
    
    final gameController = chess.ChessBoardController();
    gameController.loadPGN(pgn);

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ConfirmGamePage(gameString: pgn, whiteName: whiteName, whiteElo: whiteElo, blackName: blackName, blackElo: blackElo, event: event, location: location, isPlayer: isPlayer, date: date, gameId: gameId,)));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Color(0xff1e1a1a), width: 1.7
            )
        ),
        child: Row(
          children: [
            Container(
              width: 200,
              color: Colors.white10,
              child: chess.ChessBoard(controller: gameController, enableUserMoves: false,),
              // child: Image.network(width: 200, "https://images.chesscomfiles.com/uploads/v1/images_users/tiny_mce/CHESScom/phphK5JVu.png"),
            ),
            Expanded(
              child: Center(
                child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 7,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text("White", style: TextStyle(fontWeight: FontWeight.bold),),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    style: TextStyle(fontSize: 14),
                                    text: whiteName,
                                    children: [
                                      TextSpan(
                                          text: " ($whiteElo)"
                                      )
                                    ]
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Text("vs."),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text("Black", style: TextStyle(fontWeight: FontWeight.bold),),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(

                                    style: TextStyle(fontSize: 14),
                                    text: blackName,
                                    children: [
                                      TextSpan(
                                          text: " ($blackElo)"
                                      )
                                    ]
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(formatDate),
                    Text(event),
                    Text(location),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


