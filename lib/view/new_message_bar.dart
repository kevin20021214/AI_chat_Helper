import 'package:final_project/services/assistant.dart'; // assistant servise
import 'package:flutter/material.dart';
import 'package:final_project/model/chat_message.dart';
import 'package:final_project/model/category.dart';
import 'package:final_project/view_model/message_vm.dart';
import 'package:final_project/view_model/me_view_model.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class NewMessageBar extends StatefulWidget {
  const NewMessageBar({super.key});

  @override
  State<NewMessageBar> createState() {
    return _NewMessageBarState();
  }
}

class _NewMessageBarState extends State<NewMessageBar> {
  final _messageController = TextEditingController();
  TextEditingController _keyController = TextEditingController();
  final ChatService _chatService = ChatService();
  late RiveAnimationController _controller;
  final String _animationName = 'Edit Icon';
  // final String _animationName = 'Load'

  var _keyword='';
  var ischecked = false;
  var isgenerating = false;
  
  @override
  void _sendkeywordBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Text editing controller
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _keyController,
                decoration: InputDecoration(
                  labelText: '你想要怎麼回答?',
                ),
              ),
              SizedBox(height: 50),        
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                child: Text('生成有趣圖片',style: TextStyle(fontFamily: 'abc',color:ischecked?Theme.of(context).colorScheme.primary : Colors.grey,)),
                onPressed: () {
                  // Update the state of the main page
                  setState(() {
                    ischecked = true;
                    _keyword = _keyController.text;
                  });
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
                SizedBox(width: 20,),
                ElevatedButton(
                child: Text('生成文字回復',style: TextStyle(color:!ischecked?Theme.of(context).colorScheme.primary : Colors.grey,),),
                onPressed: () {
                  // Update the state of the main page
                  setState(() {
                    _keyword = _keyController.text;
                    ischecked = false;
                  });
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
                
              ],
            ),
            ],
          ),
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    // 初始化 TextEditingController
    _keyController = TextEditingController(text: _keyword);
    isgenerating = false;
    _controller = SimpleAnimation(_animationName, autoplay: true);
  }
  void dispose() {
    _keyController.dispose();
    _messageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    print("submit start");
    
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    if(isgenerating)return;
    setState(() {
      isgenerating = true;
    });
    FocusScope.of(context).unfocus();
    _messageController.clear();

    final meViewModel = Provider.of<MeViewModel>(context, listen: false);
    final allMessagesViewModel =
        Provider.of<AllMessagesViewModel>(context, listen: false);
    if (meViewModel.me == null) {
      return;
    }
    String _sendkey = _keyword;
    setState(() {
      _sendkey=_keyController.text;
      _keyController.clear();
      
    });
    final me = meViewModel.me!;
    Message newmessage = Message (
      user: me.name,
      text: enteredMessage,
      userID: me.id,
      category: me.recent_category,
      keywords: _sendkey,
      picture: ischecked,
      memesUrl : ""
    );
    allMessagesViewModel.addMessage(
      newmessage
    );

    //get the response from openAI
    final response = await _chatService.fetchPromptResponse(newmessage);
    //push the reponse to back-end database
    allMessagesViewModel.addMessage(
      response
    );
    setState(() {
      isgenerating = false;
    });
    print("message firebase normal");
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8, bottom: 16),
          child: (isgenerating)?
            Center(
              child:SizedBox(
              height: 100,
              width: 300,
              child: RiveAnimation.asset(
                'assets/generate.riv',
                // 'assets/ewonder.riv',
                controllers: [_controller],
                onInit: (_) => setState(() => _controller.isActive= true),
                ),
              ),
            )
            :Row(
              children: [
                IconButton(
                    onPressed:()=> _sendkeywordBottomSheet(context),
                    icon: const Icon(Icons.add),
                  ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    enableSuggestions: true,
                    decoration:
                        const InputDecoration(labelText: '你想回復什麼訊息?'),
                  ),
                ),
                IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  icon: const Icon(
                    Icons.send,
                  ),
                  disabledColor: Theme.of(context).colorScheme.error,
                  onPressed: _submitMessage,
                ),
              ],
            ),
        ),
      ),
    );
  }
}
