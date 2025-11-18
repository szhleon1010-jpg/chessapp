import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUtils {
  static Future<bool> AddGame(String pgn, String black_name, int black_elo, int white_elo, String white_name) async{
    CollectionReference gamesREF = FirebaseFirestore.instance.collection("games");
    try{
      final gameInfo = {
        "pgn": pgn,
        "black_name": black_name,
        "black_elo": black_elo,
        "white_elo": white_elo,
        "white_name": white_name,
        "dateCreated": FieldValue.serverTimestamp(),
        "user_id": FirebaseAuth.instance.currentUser!.uid
      };
      await gamesREF.doc().set(gameInfo);
      return true;
    }catch(e){
      throw Exception("Error adding new games to Firestore: $e");
    }
  }
  static Future<List<Map<String,dynamic>>> fetchAllGames() async{
    final CollectionReference gamesREF = FirebaseFirestore.instance.collection("games");
    try{
      QuerySnapshot snapshot = await gamesREF.get();
      List<Map<String, dynamic>> allUserData = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      return allUserData;
    }catch(e){
      throw Exception("Error fetching game from Firestore: $e");
    }
  }
  static Future<List<Map<String,dynamic>>> fetchUserGames() async{
    final CollectionReference gamesREF = FirebaseFirestore.instance.collection("games");
    final Userid = FirebaseAuth.instance.currentUser!.uid;
    try{
      QuerySnapshot snapshot = await gamesREF.where("user_id", isEqualTo: Userid).get();
      List<Map<String, dynamic>> allUserData = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      return allUserData;
    }catch(e) {
      throw Exception("Error fetching game from Firestore: $e");
    }
  }
}