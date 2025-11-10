import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  final confirming_controller = TextEditingController();
  Future<void> createaccount ()async {
    String email = email_controller.text;
    String password = password_controller.text;
    String confirming= confirming_controller.text;
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 16,
        children: [
          SizedBox(
            height: 45,
          ),
          Text("Sign Up", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), ),
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
              child: Text("Create Password")),
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
          SizedBox(
            width: 300,
              child: Text("Confirm Password")),
          SizedBox(
              width: 300,
              child: TextField(
                obscureText: true,
                controller: confirming_controller,
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
              createaccount();
              Navigator.pop(context);

          },
            child: Text("Confirm Info"),style: ElevatedButton.styleFrom(
              side: BorderSide(
                color: Colors.white
              )
            ),
          )
        ],
      ),
    );
  }
}
