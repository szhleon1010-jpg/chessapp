import 'package:chessapp/Services/Firebase_utils.dart';
import 'package:flutter/material.dart';

class SaveGamePage extends StatefulWidget {
  const SaveGamePage({super.key});

  @override
  State<SaveGamePage> createState() => _SaveGamePageState();
}

class _SaveGamePageState extends State<SaveGamePage> {
  List<Map<String,dynamic>> games = [];
  void loadGames() async{
    final loadedGames = await FirebaseUtils.fetchAllGames();
    setState(() {
      games = loadedGames;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Analyze")
      ],
    );
  }
  Widget gameTile(String pgn, String black_name, int black_elo, int white_elo, String white_name,String date){
    return Container(
      child: Row(
        children: [
          Image.network("https://images.chesscomfiles.com/uploads/v1/images_users/tiny_mce/CHESScom/phphK5JVu.png"),
          Container(
            child: Column(
              children: [
                Text("White"),
                RichText(
                  text: TextSpan(
                    text: white_name,
                    children: [
                      TextSpan(
                        text: "($white_elo)"
                      )
                    ]
                  ),
                ),
                Text(date),
                Text("Black"),
                RichText(
                  text: TextSpan(
                      text: black_name,
                      children: [
                        TextSpan(
                            text: "($black_elo)"
                        )
                      ]
                  ),
                ),
                ],
            ),
          )
        ],
      ),
    );
  }
}
