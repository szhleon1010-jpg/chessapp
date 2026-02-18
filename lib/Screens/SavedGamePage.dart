import 'package:chessapp/Screens/confirmPage.dart';
import 'package:chessapp/Services/Firebase_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/GameTile.dart';

class SaveGamePage extends StatefulWidget {
  const SaveGamePage({super.key});

  @override
  State<SaveGamePage> createState() => _SaveGamePageState();
}

class _SaveGamePageState extends State<SaveGamePage> {
  List<Map<String,dynamic>> games = [];
  Future<void> loadGames() async{
    final loadedGames = await FirebaseUtils.fetchUserGames();
    setState(() {
      if(loadedGames == null){
        games = [];
      }
      else{
        games = loadedGames;
      }
    });
    return ;
  }
  @override
  void initState(){
    super.initState();
    loadGames();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child:(games.isEmpty)? Center(child: CircularProgressIndicator(),):
              ListView.builder(
                  itemCount: games.length,
                  itemBuilder: (context, index){
                    final game = games[index];
                    return GameTile(
                        pgn: game["gameStr"],
                        blackName: game["black"],
                        blackElo: game["blackElo"],
                        whiteElo: game["whiteElo"],
                        whiteName: game["white"],
                        date: game["date"],
                        event: game["event"],
                        location: game["location"],
                        isPlayer: game["isPlayer"],
                        gameId: game["gameId"]);
                  })
            ),
      ],
    );
  }
}
