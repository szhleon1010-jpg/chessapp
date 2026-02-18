import 'package:chessapp/Screens/Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Constants.dart';
import 'createAccount.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  final confirming_controller = TextEditingController();
  Future<void> signIn ()async {
    try{
      String email = email_controller.text;
      String password = password_controller.text;
      String confirming= confirming_controller.text;
      FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account does not exist or password is incorrect.")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mainBackgroundColor,
      appBar: AppBar(),
      body: Center(
        child: Column(
          spacing: 13,
          children: [
            SizedBox(
              height: 45,
            ),
            Text("Sign In", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), ),
            SizedBox(
                width: 300,
                child: Text("Enter Email")),
            SizedBox(
                width: 300,
                child: TextField(
                  controller: email_controller,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 3)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2)
                      ),
                      filled: true, fillColor: Color(0xffa3a3a3)
                  ),
                )
            ),
            SizedBox(
                width: 300,
                child: Text("Enter Password")),
            SizedBox(
                width: 300,
                child: TextField(
                  obscureText: true,
                  controller: password_controller,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 3)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2)
                      ),
                      filled: true, fillColor: Color(0xffa3a3a3)
                  ),
                )
            ),
            ElevatedButton
              (onPressed: (){
              signIn();
              // Navigator.pop(context);

            },
              child: Text("Confirm Info"),style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Colors.white
                  )
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color(0xff777575)
                        )
                    )
                ),
                child: Text("Don't have an account?", style: TextStyle(
                    color: Color(0xff575757) ))),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=> CreateAccount()));
              },
              child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Color(0xff777575)
                      ),
                    ),
                  ),
                  child: Text("Tap here", style: TextStyle( color: Color(0xffc3c0c0)))),
            ),
          ],
        ),
      ),
    );
  }
}