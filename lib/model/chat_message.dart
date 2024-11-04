import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/category.dart';
// class Message {
//   final String role;
//   final String text;
//   final List<String> keywordlist;
//   Message({required this.role, required this.text,required this.keywordlist});
// }
class Message {
  String?id;
  final String text; //User input message or Gpt reply for user
  final String user; //GPT or Username
  final String userID;
  final role category;  //
  final bool picture ;//generate picture or not
  final String keywords;
  final String memesUrl;
  
  Timestamp? _createdDate;
  Timestamp get createdDate =>_createdDate ??Timestamp.now() ;
  Message({
    required this.text,
    required this.user,
    required this.userID,
    required this.category,
    required this.picture,
    required this.keywords,
    required this.memesUrl
  });
  Message._({
    required this.id,
    required this.text,
    required this.user,
    required this.userID,
    required this.category,
    required this.picture,
    required this.keywords,
    required this.memesUrl,
    required Timestamp? createdDate,
  }) :  _createdDate = createdDate;
  
  factory Message.fromMap(Map<String,dynamic> map,String id){
    
    return Message._(
      id:id,
      text: map['text'],
      user: map['user'],
      userID: map['userID'],
      category: role.values.byName(map['category']),
      createdDate: map['createdDate'],
      keywords: map['keywords'],
      memesUrl: map['memesUrl'],
      picture:map['picture']
    );
  }
  Map<String,dynamic> toMap(){
    return {
      'id' :id,
      'text':text,
      'user':user,
      'userID':userID,
      'category':category.name,
      'keywords':keywords,
      'memesUrl':memesUrl,
      'picture':picture,
      'createdDate':_createdDate
    };
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}