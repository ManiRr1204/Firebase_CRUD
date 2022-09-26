import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flog_demo_test/user_model.dart';

class FireStoreHelper {
  static Future create(UserModel user) async {
    final userCollections = FirebaseFirestore.instance.collection("first_data");

    final uid = userCollections.doc().id;
    final user_doc = userCollections.doc(uid);

    final newUser = UserModel(
            id: uid, name: user.name, age: user.age, isSingle: user.isSingle)
        .toJson();

    try {
      await user_doc.set(newUser);
    } catch (e) {
      print("Firebase Data Creation is Failded [error] : $e");
    }
  }

  static Stream<List<UserModel>> read() {
    final userCollections = FirebaseFirestore.instance.collection("first_data");

    return userCollections.snapshots().map((querySnapShot) =>
        querySnapShot.docs.map((e) => UserModel.fromSnapShot(e)).toList());
  }

  static Future update(UserModel user) async {
    final userCollections = FirebaseFirestore.instance.collection("first_data");

    final user_doc = userCollections.doc(user.id);

    final newUser = UserModel(
            id: user.id,
            name: user.name,
            age: user.age,
            isSingle: user.isSingle)
        .toJson();

    try {
      await user_doc.update(newUser);
    } catch (e) {
      print("Firebase Data Updating is Failded [error] : $e");
    }
  }

  static Future delete(UserModel user) async {
    final userCollections = FirebaseFirestore.instance.collection("first_data");
    try {
      await userCollections.doc(user.id).delete();
    } catch (e) {
      print("Firebase Data Deleting is Failded [error] : $e");
    }
  }
}
