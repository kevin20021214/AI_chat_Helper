import 'dart:async';
import 'dart:convert';
import 'package:final_project/model/chat_message.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static const String _apiKey =
      ''; // FIXME: Replace with your API key
  static const String _url = 'https://api.openai.com/v1/images/generations';

  // final _messagesStreamController =
  //     StreamController<List<Message>>.broadcast();
  // Assume that the messages are stored in descending order (latest message first)
  // final List<Message> _messages = [];

  // Stream<List<Message>> get messagesStream =>
  //     _messagesStreamController.stream;

  // Future<void> fetchMessages() async {
  //   // Simulating fetching past messages (not applicable with OpenAI's completions API directly)
  //   await Future.delayed(const Duration(seconds: 1));
  //   _messagesStreamController.add(List.of(_messages));
  // }

  Future<Message> fetchPromptResponse(Message prompt) async {
    // _messages.insert(0, Message(role: 'user', text: prompt));
    // _messages.insert(
    //   0,
    //   Message(role: 'assistant', text: 'Generating response...'),
    // );
    // _messagesStreamController.add(List.from(_messages));

    // 1. Send the prompt to the DALL-E API to generate an image
    var response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'prompt': prompt.text,
        'n': 1,
        'size': '256x256', // You can adjust the image size as needed
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to generate image: ${response.statusCode}');
    }

    // 2. Update local messages list with the assistant's response
    var data = json.decode(utf8.decode(response.bodyBytes));
    var imageUrl = data['data'][0]['url'];

    //only implemented one imageUrl servise
    Message responseMessage = Message (
      user: 'GPT',
      text: '',
      userID: prompt.userID,
      category: prompt.category,
      keywords: prompt.keywords,
      picture: prompt.picture,
      memesUrl : imageUrl
    );

    // _messages[0] = Message(role: 'assistant', text: 'Here is the image: $imageUrl');
    // print(imageUrl);
    // 4. Update the stream with the new messages list
    // _messagesStreamController.add(List.from(_messages));
    return responseMessage; 
  }
  // void dispose() {
  //   _messagesStreamController.close();
  // }
}