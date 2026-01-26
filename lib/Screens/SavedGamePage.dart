import 'package:chessapp/Screens/confirmPage.dart';
import 'package:chessapp/Services/Firebase_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                    return gameTile(game["gameStr"], game["black"],game["blackElo"], game["whiteElo"], game["white"],game["date"], game["event"], game["location"], game["isPlayer"]);
                  })
            ),
      ],
    );
  }
  Widget gameTile(String pgn, String black_name, String black_elo, String white_elo, String white_name, Timestamp date, String event, String location, String isPlayer){
    final tempDate = date.toDate();
    final formatDate = DateFormat("MM/dd/yyyy").format(tempDate);
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ConfirmGamePage(gameString: pgn, whiteName: white_name, whiteElo: white_elo, blackName: black_name, blackElo: black_elo, event: event, location: location, isPlayer: isPlayer, date: date)));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xff1e1a1a), width: 1.7
          )
        ),
        child: Row(
          children: [
            Image.network(width: 200, "https://images.chesscomfiles.com/uploads/v1/images_users/tiny_mce/CHESScom/phphK5JVu.png"),
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
