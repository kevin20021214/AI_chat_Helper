import 'package:final_project/model/login_method.dart';
import 'package:final_project/model/category.dart';
import 'package:flutter/foundation.dart';
class User {
  String id;
  final String email;
  final String name;
  String devicetoken = '';//暫時無用
  late final List<LoginMethod> logInMethods;
  late final role recent_category;

  User({
    required this.id,
    required this.email,
    required this.name,
    recent_category,
    logInMethods,
  }) : recent_category = recent_category ?? role.nothing,
      logInMethods = logInMethods ?? [];

  User._({
    required this.id,
    required this.email,
    required this.name,
    recent_category,
    devicetoken = '',
    logInMethods,
  }) : recent_category  = recent_category ?? role.nothing,
  logInMethods = logInMethods??[];

  factory User.fromMap(Map<String,dynamic>map,String id){
    return User._(
      id: id, 
      email: map['email'], 
      name: map['name'],
      recent_category: role.values.byName(map['recent_category']),
      devicetoken : map['devicetoken'],
      logInMethods:  (map['logInMethods'] as List<dynamic>)
          .map((logInMethod) => LoginMethod.values.byName(logInMethod))
          .toList(),
    );
  }
  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'email':email,
      'name':name,
      'recent_category':recent_category.name,
      'logInMethods':logInMethods.map((logInMethod) => logInMethod.name).toList(),
      'devicetoken':devicetoken
    };
  }
}