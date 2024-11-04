import 'package:flutter/material.dart';
import 'package:final_project/view_model/message_vm.dart';
import 'package:final_project/view_model/me_view_model.dart';
import 'package:final_project/view/message_bubble.dart';
import 'package:provider/provider.dart';
import 'package:final_project/view/animate_message_bubble.dart';
class MessageList extends StatelessWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final meViewModel = Provider.of<MeViewModel>(context);
    final allMessagesViewModel = Provider.of<AllMessagesViewModel>(context);
    if (meViewModel.me == null || allMessagesViewModel.isInitializing) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final me = meViewModel.me!;
    final messages = allMessagesViewModel.messages.where((element) => element.category == me.recent_category).toList();

    if (messages.isEmpty) {
      return const Center(
        child: Text('你還沒有提出任何問題喔'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 16,
        bottom: 16,
        left: 8,
        right: 8,
      ),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (ctx, index) {
        final message = messages[index];
        final nextMessage =
            index + 1 < messages.length ? messages[index + 1] : null;
        final prevMessage = index - 1 >= 0 ? messages[index - 1] : null;
        final messageUserId = message.userID;
        final messageUser = message.user;
        final nextMessageUserId = nextMessage?.user;
        
        final isNextUserSame = nextMessageUserId == message.user;
        final preMessageUserId = prevMessage?.user;
        final isPreUserSame = preMessageUserId == messageUser;
        final isURL = message.picture;
          if (isNextUserSame) {
            return AnimatedMessage(
              isURL: false,
              text: message.text,
              isMine: me.name == messageUser,
              isLast: !isPreUserSame,
              memesUrl: "",
            );
          } else if(!isNextUserSame) {
            if(isURL){
              return AnimatedMessage.withUser(
                userName: '推薦你回復這張圖',
                text: message.text,
                isMine: me.name == messageUser,
                isLast: !isPreUserSame,
                isURL: isURL,
                memesUrl:message.memesUrl,
              );
            }
            else{
              return AnimatedMessage.withUser(
                userName: '你可以回復他:',
                text: message.text,
                isMine: me.name == messageUser,
                isLast: !isPreUserSame,
                isURL: isURL,
                memesUrl:"",
              );            
            }
          }
      },
    );
  }
}
