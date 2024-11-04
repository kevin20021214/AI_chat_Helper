import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/category.dart';
import 'package:final_project/model/chat_message.dart';
import 'package:flutter/foundation.dart';
class MessageRepository {
 final  FirebaseFirestore _db = FirebaseFirestore.instance;
 Stream<List<Message>>streamMessage(String userId){
  try {
    return _db
      .collection('apps/final-project/users/$userId/messages')
      .orderBy('createdDate', descending: true)
      .snapshots()
      .handleError((error) {
        print('Error in Firestore snapshot: $error');
      }).map((snapshot) {
        if (snapshot.docs.isEmpty) {
          print('No messages found.');
          return [];
        }
        return snapshot.docs
        .map((doc) => Message.fromMap(doc.data(), doc.id))
        .toList();
        
      });
  } catch (e) {
    print('Exception in streamMessage: $e');
    return Stream.value([]); // Return an empty list stream on exception
  }
 }
 
 Future<String>addMessage(Message message)async{
  Map<String,dynamic>messageMap =message.toMap();
  print("message Map");
  String userId = message.userID;
  messageMap.remove('id');
  messageMap['createdDate'] = FieldValue.serverTimestamp();
  try{
    DocumentReference docRef = await _db
    .collection('apps/final-project/users/$userId/messages')
    .add(messageMap);
    print("suceesfully finish sending message");
    return docRef.id;
  }
  catch (e){
    print("there is error when send a message to backend => $e");
    return userId;
  }
 }
}