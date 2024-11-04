import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/user.dart';
import 'package:flutter/foundation.dart';
class UserRepository{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  Stream<User?>streamUser(String userId){
    return _db
      .collection('apps/final-project/users')
      .doc(userId)
      .snapshots()
      .map((snapshot) {
        return snapshot.data() == null
          ?null
          :User.fromMap(snapshot.data()!,snapshot.id);
      });
  }

  Future <void> createOrUpdateUser (User user) async{
    Map<String,dynamic> userMap = user.toMap();
    try {
      await _db
        .collection('apps/final-project/users')
        .doc(user.id)
        .set(userMap);
      print("User data successfully written!");
    } catch (e) {
      print("Error writing user data: $e");
    }
  }
  Future <User?> getUserByEmail(String Email)async{
    QuerySnapshot querySnapshot = await _db
        .collection('apps/final-project/users')
        .where('email', isEqualTo: Email)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    return User.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>,
        querySnapshot.docs.first.id);
  }
}