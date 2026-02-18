import 'package:chessapp/widgets/GameData.dart';
import 'package:chessapp/widgets/GameTile.dart';
import 'package:chessapp/widgets/RatingChart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Services/Firebase_utils.dart';
import 'confirmPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int rating = 1200;
  int winRate = 100;
  List <int> winLoseDraw = [0,0,0];
  List <GameData> gameData = [];
  List<Map<String,dynamic>> games = [];
  Future<void> loadGames() async{
    final loadedGames = await FirebaseUtils.fetchUserGames();
    setState(() {
      if(loadedGames == null){
        games = [];
      }
      else{
        games = loadedGames;
        loadGameData();
      }
    });
    return ;
  }
  void loadGameData()async{
    for(Map <String,dynamic> game in games){
      int tempRating = 0;
      List <String> gameStr = game["gameStr"].split(" ");
      String res = gameStr[gameStr.length - 1];
      if(game["isPlayer"] == "White"){
        tempRating = int.parse(game["whiteElo"]);
        if(res == "1-0"){
          winLoseDraw[0] += 1;
        }
        else if(res == "1/2-1/2"){
          winLoseDraw[2] += 1;
        }
        else{
          winLoseDraw[1] += 1;
        }
      }
      else if (game["isPlayer"] == "Black"){
        tempRating = int.parse(game["blackElo"]);
        if(res == "0-1"){
          winLoseDraw[0] += 1;
        }
        else if(res == "1/2-1/2"){
          winLoseDraw[2] += 1;
        }
        else{
          winLoseDraw[1] += 1;
        }
      }
      if(tempRating != 0){
        gameData.add(GameData(tempRating, game["date"], res, game));
      }
    }
    gameData.sort((a, b) => b.date.compareTo(a.date));
    winRate = (winLoseDraw[0] / (winLoseDraw[0] + winLoseDraw[1] + winLoseDraw[2]) * 100).round();
    if(gameData.isNotEmpty){
      rating = gameData[0].rating;
    }

    print(gameData);
  }
  @override
  void initState(){
    super.initState();
    loadGames();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        SizedBox(
          height: 1.0,
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xff777474)
            ),
            child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 Column(
                   spacing: 5,
                   children: [
                     Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xff5a5a5a)
                      ),
                       child: CircleAvatar(
                         radius: 35,
                        backgroundImage: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/0/03/Twitter_default_profile_400x400.png"),
                       ),
                     ),
                     Text("user123456789", style: TextStyle(fontSize: 20),),
                   ],
                 ),
                 Container(
                   padding: EdgeInsets.all(8),
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(5),
                       color: Color(0xff5a5a5a)
                   ),
                   child: Column(
                     children: [
                       Column(
                         children: [
                           Text("rating/elo: ${rating.toString()}", style: TextStyle(fontSize: 17),),
                           Text("Win rate: ${winRate.toString()}%", style: TextStyle(fontSize: 17),),
                           Text("Win/Lose/Draw: ${winLoseDraw.join('/')}", style: TextStyle(fontSize: 17),)
                         ],
                       ),
                     ],
                   ),
                 )
               ],
            ),
          ),
        ),
        Container(
          width: 500,
          height: 250,
          margin: EdgeInsets.only(left: 5, right: 5),
          padding: EdgeInsets.all(10),
            child: (gameData.isNotEmpty) ? RatingChart(gameData: gameData,) : Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator())),
        ),
        Expanded(
            child:(gameData.isEmpty)? Center(child: CircularProgressIndicator(),):
            ListView.builder(
                itemCount: gameData.length,
                itemBuilder: (context, index){
                  final game = gameData[index].data;
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
