import 'dart:convert';
import 'dart:io';

import 'package:chessapp/Screens/ViewGame.dart';
import 'package:chessapp/Screens/confirmPage.dart';
import 'package:chessapp/Services/OpenAIprompt.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}
enum menuAction {
  Choose, Take
}
class _UploadPageState extends State<UploadPage> {
  final textcontroller = TextEditingController();
  final imagePicker = ImagePicker();
  File? image;
  String GameString= "";
  void gotoConfirmScreen()async{
    String test = await OpenAIprompt.test();
    print(test);
    // if(image != null){
    //   final bytes = await image!.readAsBytes();
    //   String base64image = base64Encode(bytes);
    //   String PGN = await OpenAIprompt.getPGNfromImage(base64image);
    //   print(PGN);
    // } else{
    //   Navigator.push(context, MaterialPageRoute(builder: (_)=>ConfirmGamePage(gameString:cleanPGN(GameString))));
    // }
  }
  String cleanPGN(String pgn) {
    return pgn
    // Remove invisible or non-breaking spaces
        .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF\u00A0]'), '')
    // Remove comments in braces { ... }
        .replaceAll(RegExp(r'\{[^}]*\}'), '')
    // Remove ellipses
        .replaceAll('..', '')
    // Trim leading/trailing spaces
        .trim();
  }
  void ChoosePhoto(ImageSource Source) async{
    final XFile? pickedFile = await imagePicker.pickImage(source: Source);
    if(pickedFile != null){
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Upload Image ", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold
              ),),
              Text("Recording sheet of PGN or FEN"),
              SizedBox(
                height: 35,
              ),
              Center(
                  child: PopupMenuButton<menuAction>(
                    onSelected: (menuAction action){
                      if(action == menuAction.Take){
                        ChoosePhoto(ImageSource.camera);
                      }
                      else if (action == menuAction.Choose){
                        ChoosePhoto(ImageSource.gallery);
                      }
                    },
                    itemBuilder: (context)=>[
                      PopupMenuItem(child: Text("Take Photo"), value: menuAction.Take,),
                      PopupMenuItem(child: Text("Choose From Gallery"), value: menuAction.Choose,)
                    ],
                    child: (image == null)?Container(
                      padding: EdgeInsets.all(8), // Border width
                      decoration: BoxDecoration( borderRadius: BorderRadius.circular(10000)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(60), // Image radius
                          child: Image.network('https://static.vecteezy.com/system/resources/previews/011/912/003/non_2x/plus-sign-icon-free-png.png'
                              , fit: BoxFit.cover),
                        ),
                      ),
                    ):Image.file(image!),
                  )
              ),
              SizedBox(height: 50,),
              Text("Input PGN or FEN", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              Text("Paste Chess Notation Below", style: TextStyle(fontSize: 18),),
              SizedBox(

                  width: 300,
                  child: TextField(
                    onChanged:(str){
                      GameString = str;
                    },
                    controller: textcontroller,
                    minLines: 5,
                    maxLines: 5,
                    decoration: InputDecoration(
                      filled: true, fillColor: Color(0xff2c2c2c)
                    ),
                    style: TextStyle(color: Colors.white),
                )
              ),
              SizedBox(height: 50,),
              ElevatedButton
                (onPressed: (){
                  gotoConfirmScreen();
              },
                  child: Text("Analyze"),
            )
            ]
          ),
        ),
      ),
    );
  }
}
