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
  late final whiteController = TextEditingController(text: widget.gameInfo["white"],);
  late final blackController = TextEditingController(text: widget.gameInfo["black"],);
  late final eventController = TextEditingController(text: widget.gameInfo["event"],);
  late final locationController = TextEditingController(text: widget.gameInfo["location"],);
  List<TextEditingController> moveControllers = [];
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
  void updateNewInfo(){
    List<String> newMoves = [];
    for(int i = 0; i < widget.moves.length; i++){
      newMoves.add("${i + 1}. ${moveControllers[i * 2].text} ${moveControllers[i * 2 + 1].text}");
    }
    widget.updateGameInfo(
        {
          "white": whiteController.text,
          "black": blackController.text,
          "event": eventController.text,
          "location": locationController.text,
          "date": selectedDate,
          "gameStr": newMoves.join(" "),
        }
    );
  }
  @override
  void initState(){
    super.initState();
    for(int i = 0; i < widget.moves.length; i++){
      final m = widget.moves[i]?.split(" ");
      if(m?.length == 3){
        for(int a = 1; a <= 2; a++){
          moveControllers.add(TextEditingController(text: m?[a]));
        }
      }
    }
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
                if(moveControllers.isEmpty){
                  return CircularProgressIndicator();
                }
                final info = widget.moves[index]?.split(" ");
                if(info?.length == 3){
                  return moveCell(info![0],
                      moveControllers[index * 2],
                      moveControllers[index * 2 + 1]);
                }
                else{
                  return Container();
                }
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
                        width: 200,
                        child: TextFormField(

                          controller: whiteController,
                        ),
                      ),
                      Text("Rating"),
                      SizedBox(
                        height: 50,
                        width: 90,
                        child: TextFormField(

                          controller: whiteController,
                        ),
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
                        child: TextFormField(
                          controller: blackController,
                        ),
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
                          child: TextFormField(
                            controller: eventController,
                          ),
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
                        child: TextFormField(
                          controller: locationController,
                        ),
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
            onPressed: (){
              widget.updateGameInfo(widget.gameInfo);
              Navigator.pop(context);
            }, style: ElevatedButton.styleFrom(
              side: BorderSide(
                  color: Colors.white
              )
          ),
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
  Widget moveCell(String moveNum, TextEditingController W, TextEditingController B){
    return SizedBox(
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
                    child: TextFormField(controller:W)),
                SizedBox(
                    width: 125,
                    child: TextFormField(controller:B)),
              ],
            ),
          )
        ],
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    for(TextEditingController controller in moveControllers){
      controller.dispose();
    }
    super.dispose();
  }
}
