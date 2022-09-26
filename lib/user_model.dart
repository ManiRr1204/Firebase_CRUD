import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String name;
  final String age;
  final String isSingle;

  UserModel({required this.name, required this.age, required this.isSingle,this.id});

  factory UserModel.fromSnapShot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      id: snapshot['id'],
        name: snapshot["name"],
        age: snapshot["age"],
        isSingle: snapshot["single?"]);
  }

  Map<String, dynamic> toJson() =>
      {"id": id,"name": name, "age": age, "single?": isSingle};
}
