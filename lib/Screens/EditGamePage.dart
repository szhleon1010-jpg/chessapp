import 'package:flutter/material.dart';

class EditGamePage extends StatefulWidget {
  final List <String?> moves;
  final Map <String, dynamic> gameInfo;
  final Function updateGameInfo;
  const EditGamePage({super.key,required this.moves, required this.gameInfo, required this.updateGameInfo});

  @override
  State<EditGamePage> createState() => _EditGamePageState();
}

class _EditGamePageState extends State<EditGamePage> {
  DateTime? selectedDate;
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1830),
      lastDate: DateTime.now(),
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }
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
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 35),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("White"),
                      SizedBox(
                        height: 50,
                        width: 300,
                        child: TextFormField(initialValue: widget.gameInfo["white"],),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Black"),
                      SizedBox(
                        height: 50,
                        width: 300,
                        child: TextFormField(initialValue: widget.gameInfo["black"],),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Date"),
                      SizedBox(
                        height: 50,
                        width: 300,
                        child: ElevatedButton(onPressed: ()=>_selectDate(), child: Text(
                          selectedDate != null
                              ? '${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}'
                              : 'No date selected',
                        ),)
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Event"),
                      SizedBox(
                        height: 50,
                        width: 300,
                          child: TextFormField(initialValue: widget.gameInfo["event"],),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Location"),
                      SizedBox(
                        height: 50,
                        width: 300,
                        child: TextFormField(initialValue: widget.gameInfo["location"],),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () => widget.updateGameInfo(
              widget.gameInfo
            ),
            child: Text("Save"),style: ElevatedButton.styleFrom(
              side: BorderSide(
                  color: Colors.white
              )
          ),
          ),
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
