import 'package:final_project/repositories/user_repo.dart';
import 'package:flutter/material.dart';
//import 'package:final_project/services/authentication.dart';
import 'package:final_project/view_model/me_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:final_project/model/category.dart';
import 'package:final_project/model/user.dart';
class StartPage extends StatefulWidget {
  const StartPage({super.key}); //call back function
  @override
  State<StartPage> createState() => _StartState();
}

class _StartState extends State<StartPage> {
  role nowrole = role.family;
  @override
  void initState() {
    super.initState();
    nowrole = Provider.of<MeViewModel>(context, listen: false).me!.recent_category;
    // Initialize `_pushMessagingService` without awaiting, so that the `build` method can run
    //final menow = Provider.of<MeViewModel>(context, listen: false).me!;
  }
  void changerole(role select){
    setState(() {
      nowrole = select;
    });
    final menow = Provider.of<MeViewModel>(context, listen: false).me!;
    Map<String,dynamic> temp = menow.toMap();
    temp["recent_category"] = select.name;
    final UserRepository _userRepository=UserRepository();
    _userRepository.createOrUpdateUser(User.fromMap(temp, menow.id));
  }
  
  @override
  Widget build(context) {
     return Material(
       child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '選擇你的聊天對象!',
                style: TextStyle(
                  fontFamily: 'abc',
                  fontSize: 55,
                )
                ),
              const SizedBox(height: 80,),
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
                            icon: Icon(Icons.family_restroom),
                            iconSize: 120
                          ),
                          const Text('家人', style: TextStyle(fontFamily: 'abc',fontSize: 30,color: Colors.black,),)
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Column(
                        children: [
                          IconButton(
                            onPressed: ()=>changerole(role.lover),
                            color: (nowrole==role.lover) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.inversePrimary,
                            icon: const Icon(Icons.favorite),
                            iconSize: 120),
                          const Text('情人', style: TextStyle(fontFamily: 'abc',fontSize: 30,color: Colors.black,),)
                        ],
                      ),
                    ],          
                    
                  ),
                  const SizedBox(width: 40,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            onPressed: ()=>changerole(role.elder),
                            color: (nowrole==role.elder) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.inversePrimary,
                            icon: const Icon(Icons.elderly),
                            iconSize: 120),
                          const Text('長輩',style: TextStyle(fontFamily: 'abc',fontSize: 30,color: Colors.black,),)
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Column(
                        children: [
                          IconButton(
                            onPressed: ()=>changerole(role.friend),
                            color: (nowrole==role.friend) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.inversePrimary,
                            icon: const Icon(Icons.face_2),
                            iconSize: 120),
                          const Text('朋友',style: TextStyle(fontFamily: 'abc',fontSize: 30,color: Colors.black,),)
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: (){
                          changerole(nowrole);
                          context.go('/chat', extra: nowrole.name);
                          },
                        color: Theme.of(context).colorScheme.inversePrimary,
                        icon: const Icon(Icons.next_plan),
                        iconSize: 100
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
           ),
     );
  }
}
