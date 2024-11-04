import 'package:flutter/material.dart';
import 'package:final_project/services/authentication.dart';
import 'package:final_project/view_model/me_view_model.dart';
import 'package:final_project/view/message_list.dart';
import 'package:final_project/view/new_message_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:final_project/view/setting.dart';
import 'package:final_project/repositories/user_repo.dart';
import 'package:final_project/model/category.dart';
import 'package:final_project/model/user.dart';

class ChatPage extends StatefulWidget {

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {


  late final User me ;

  role nowrole = role.family;
  @override
  void initState() {
    super.initState();
    me = Provider.of<MeViewModel>(context, listen: false).me!;
    nowrole = me.recent_category;
    // Initialize `_pushMessagingService` without awaiting, so that the `build` method can run
  }
  @override
  void dispose() {
    // Do NOT unsubscribe from the topic here, as the user may want to receive notifications even when the app is in the background
    // _pushNotificationService.unsubscribeFromAllTopics();
    super.dispose();
  }
  
  void changerole(role select){
    final menow = Provider.of<MeViewModel>(context, listen: false).me!;
    Map<String,dynamic> temp = menow.toMap();
    temp["recent_category"] = select.name;
    final UserRepository _userRepository=UserRepository();
    final menew =User.fromMap(temp, menow.id);
    _userRepository.createOrUpdateUser(menew);
    setState(() {
      nowrole = select;
    });
  }
  void _openPromptOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          color: Theme.of(context).colorScheme.surface,
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){Navigator.pop(context);changerole(nowrole);}, icon: const Icon(Icons.cancel),iconSize: 20),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('現在要回復誰呢?',style: TextStyle(fontFamily: 'abc',fontSize: 50),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: ()=>changerole(role.family),
                              color: (nowrole==role.family) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.inversePrimary,
                              icon: const Icon(Icons.family_restroom),
                              iconSize: 40
                            ),
                            const Text('家人', style: TextStyle(fontFamily: 'abc',fontSize: 30,color: Colors.black,),)
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Column(
                          children: [
                            IconButton(
                              onPressed: ()=>changerole(role.lover),
                              color: (nowrole==role.lover) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.inversePrimary,
                              icon: const Icon(Icons.favorite),
                              iconSize: 40
                            ),
                            const Text('情人', style: TextStyle(fontFamily: 'abc',fontSize: 30,color: Colors.black,),)
                          ],
                        ),
                      ],          
                    ),
                    const SizedBox(width: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: ()=>changerole(role.elder),
                              color: (nowrole==role.elder) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.inversePrimary,
                              icon: const Icon(Icons.elderly),
                              iconSize: 40
                            ),
                            const Text('長輩',style: TextStyle(fontFamily: 'abc',fontSize: 30,color: Colors.black,),)
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Column(
                          children: [
                            IconButton(
                              onPressed: ()=>changerole(role.friend),
                              color: (nowrole==role.friend) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.inversePrimary,
                              icon: const Icon(Icons.face_2),
                              iconSize: 40
                            ),
                            const Text('朋友',style: TextStyle(fontFamily: 'abc',fontSize: 30,color: Colors.black,),)
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if(nowrole == role.elder)Text("長輩",style:TextStyle(fontFamily: 'abc',color: Color.fromRGBO(1, 96, 4, 1))),
            if(nowrole == role.lover)Text("情人",style:TextStyle(fontFamily: 'abc',color: Color.fromARGB(255, 255, 127, 170))),
            if(nowrole == role.family)Text("家人",style:TextStyle(fontFamily: 'abc',color:Color.fromARGB(255, 243, 91, 4)) ),
            if(nowrole == role.friend)Text("朋友",style:TextStyle(fontFamily: 'abc',color: Color.fromARGB(255, 191, 125, 3)) ),
            const SizedBox(width: 15),
            const Text('聊天助手'),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: _openPromptOverlay,
                icon: const Hero(
                  tag: 'family',
                  child: Icon(Icons.settings),
                ),
              ),
              const SizedBox(width: 10,),
              IconButton(
                onPressed: () {
                  Provider.of<AuthenticationService>(context, listen: false)
                      .logOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(
            child: MessageList(),
          ),
          NewMessageBar(),
        ],
      ), 
    );
  }
}
