import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUtils {
  static Future<bool> AddGame(Map <String, dynamic> gameInfo) async{
    CollectionReference gamesREF = FirebaseFirestore.instance.collection("games");
    try{
      gameInfo ["dateCreated"] = FieldValue.serverTimestamp();
      gameInfo ["user_id"] = FirebaseAuth.instance.currentUser!.uid;
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
  static Future<List<Map<String,dynamic>>?> fetchUserGames() async{
    try{
      final CollectionReference gamesREF = FirebaseFirestore.instance.collection("games");
      final Userid = FirebaseAuth.instance.currentUser!.uid;
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