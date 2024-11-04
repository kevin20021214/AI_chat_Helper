import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:final_project/model/chat_message.dart';
import 'package:final_project/repositories/message_repo.dart';
import 'package:final_project/model/category.dart';

class AllMessagesViewModel with ChangeNotifier{
  final MessageRepository _messageRepository;
  StreamSubscription<List<Message>>?_messageSubscription;
  List<Message> _messages = [];
  List<Message> get messages =>_messages;
  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  //final String userID ;
  AllMessagesViewModel({required String userID,MessageRepository?messageRepository})
    :_messageRepository = messageRepository??MessageRepository(){
    _messageSubscription = _messageRepository.streamMessage(userID).listen(
      (messages) {
        _isInitializing = false;
        print('there are '+messages.length.toString()+' messages');
        _messages = messages;
        notifyListeners();
      }
    );
  }
  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  Future<String> addMessage(Message newMessage) async {
    return await _messageRepository.addMessage(newMessage);
  }
}

