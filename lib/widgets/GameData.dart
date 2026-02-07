import 'package:cloud_firestore/cloud_firestore.dart';

class GameData {
  int rating;
  Timestamp date;
  String result;
  Map<String,dynamic> data;
  GameData (this.rating, this.date, this.result, this.data);
}