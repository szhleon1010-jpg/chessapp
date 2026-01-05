import 'package:flutter/material.dart';

class EditGamePage extends StatefulWidget {
  final List <String?> moves;
  const EditGamePage({super.key,required this.moves});

  @override
  State<EditGamePage> createState() => _EditGamePageState();
}

class _EditGamePageState extends State<EditGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0b0a0a),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff171515),
        title: Text("Edit Info"),
      ),
      body: Column(
        children: [
          Container(
            height: 400,
            child:
            ListView.builder(
              shrinkWrap: false,
              itemCount: widget.moves.length,
              itemBuilder: (context, index){
                final info = widget.moves[index]?.split(" ");
                return movecell(info![0], info[1], info[2]);
              },
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text("White"),
                SizedBox(
                  height: 50,)
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget movecell(String moveNum, String W, String B){
    return Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            moveNum,
            style: TextStyle(
              fontSize: 15
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              bottom: 7
            ),
            width: 250,
            height: 30,
            child: Row(
              children: [
                SizedBox(
                    width: 125,
                    child: TextFormField(initialValue:W)),
                SizedBox(
                    width: 125,
                    child: TextFormField(initialValue:B)),

              ],
            ),
          )
        ],
      ),
    );
  }
}
