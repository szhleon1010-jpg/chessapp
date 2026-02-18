import 'package:chessapp/widgets/GameData.dart';
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
                  return gameTile(game["gameStr"], game["black"],game["blackElo"], game["whiteElo"], game["white"],game["date"], game["event"], game["location"], game["isPlayer"], game["gameId"]);
                })
        ),
      ],
    );
  }
  Widget gameTile(String pgn, String black_name, String black_elo, String white_elo, String white_name, Timestamp date, String event, String location, String isPlayer, String gameId){
    final tempDate = date.toDate();
    final formatDate = DateFormat("MM/dd/yyyy").format(tempDate);
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ConfirmGamePage(gameString: pgn, whiteName: white_name, whiteElo: white_elo, blackName: black_name, blackElo: black_elo, event: event, location: location, isPlayer: isPlayer, date: date, gameId: gameId,)));
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
            ),
            // Image.network(width: 200, "https://images.chesscomfiles.com/uploads/v1/images_users/tiny_mce/CHESScom/phphK5JVu.png"),
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
                                    text: white_name,
                                    children: [
                                      TextSpan(
                                          text: " ($white_elo)"
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
                                    text: black_name,
                                    children: [
                                      TextSpan(
                                          text: " ($black_elo)"
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
