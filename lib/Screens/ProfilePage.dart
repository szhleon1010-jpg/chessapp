import 'package:chessapp/widgets/line_chart_sample5.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                           Text("rating/elo: 9999", style: TextStyle(fontSize: 17),),
                           Text("Win rate: 100%", style: TextStyle(fontSize: 17),),
                           Text("Win/Lose/Draw: 1/0/0", style: TextStyle(fontSize: 17),)
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
          child: LineChartSample5(gradientColor1: Colors.red, gradientColor2: Colors.blue, gradientColor3: Colors.green, indicatorStrokeColor: Colors.white),
        ),
        CircularProgressIndicator()
      ],
    );
  }
  Widget gameTile(String pgn, String black_name, int black_elo, int white_elo, String white_name,String date){
    return GestureDetector(
      onTap: (){
       // Navigator.push(context, MaterialPageRoute(builder: (_)=>ConfirmGamePage(gameString: pgn)));
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
                    Text("White", style: TextStyle(fontWeight: FontWeight.bold),),
                    RichText(
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
                    Text(date),
                    Text("Black", style: TextStyle(fontWeight: FontWeight.bold),),
                    RichText(
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
            )
          ],
        ),
      ),
    );
  }
}
