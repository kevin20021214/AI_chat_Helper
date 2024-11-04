

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:final_project/view/big_picture.dart';
class MessageBubble extends StatelessWidget {
  // Create a message bubble which is meant to be the first in the sequence.
  MessageBubble.withUser({
    super.key,
    required this.userName,
    required this.text,
    required this.isMine,
    required this.isLast,
    required this.isURL,
    required this.memesUrl
  });

  // Create a amessage bubble that continues the sequence.
  MessageBubble({
    super.key,
    required this.text,
    required this.isMine,
    required this.isLast,
    required this.isURL,
    required this.memesUrl
  }):userName = null;

  // Whether this message bubble is the last in a sequence of messages from the same user. Modifies the message bubble slightly for these different cases - only shows user image for the first message from the same user, and changes the shape of the bubble for messages thereafter.
  final bool isLast;

  // Image of the user to be displayed next to the bubble. Not required if the message is not the first in a sequence.

  // Username of the user.  Not required if the message is not the first in a sequence.
  final String? userName;
  final String text;

  // Controls how the MessageBubble will be aligned.
  final bool isMine;
  final bool isURL;
  final String memesUrl;
  // Callback to delete the message.
  void _openPromptOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (cxt) {
        return BigPicture(memesUrl);
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          // Add some margin to the edges of the messages, to allow space for the user's image.
          margin: EdgeInsets.symmetric(horizontal: isMine ? 0 : 24),
          child: Row(
            // The side of the chat screen the message should show at.
            mainAxisAlignment:
                isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // First messages in the sequence provide a visual buffer at the top.
                  if (!isMine && userName != null) const SizedBox(height: 18),
                  if (!isMine && userName != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: 4,
                      ),
                      child: Text(
                        userName!,
                        style: const TextStyle(
                          fontFamily: 'abc',
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  Column(
                    // The "speech" box surrounding the message.
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isMine
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primaryContainer,
                          // Only show the message bubble's "speaking edge" if first in the chain. Whether the "speaking edge" is on the left or right depends on whether or not the message bubble is the current user.
                          borderRadius: BorderRadius.only(
                            topLeft: !isMine
                                ? Radius.zero
                                : const Radius.circular(16),
                            topRight: isMine
                                ? Radius.zero
                                : const Radius.circular(16),
                            bottomLeft: isMine || isLast
                                ? const Radius.circular(16)
                                : Radius.zero,
                            bottomRight: !isMine || isLast
                                ? const Radius.circular(16)
                                : Radius.zero,
                          ),
                        ),
                        // Set some reasonable constraints on the width of the message bubble so it can adjust to the amount of text it should show.
                        constraints: const BoxConstraints(maxWidth: 200),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        // Margin around the bubble.
                        margin: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children:[
                              (isURL&&!isMine)?
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                text,
                                style: TextStyle(
                                  fontFamily: 'abc',
                                  // Add a little line spacing to make the text look nicer when multilined.
                                  height: 1.3,
                                  color: isMine
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onPrimaryContainer,
                                ),
                                softWrap: true,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(onPressed: (){
                                      Clipboard.setData(ClipboardData(text: text));
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('複製完成'),
                                          content: const Text(
                                              '訊息已複製到剪貼簿上'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('Okay'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }, icon: Icon(Icons.copy,size: 10.0)),
                                  ],
                                ),
                                GestureDetector(
                                  // onTap: _isValidUrl ? () => _openPromptOverlay(context) : null,
                                  onTap: () => _openPromptOverlay(context),
                                  child: Image.network(
                                    memesUrl,
                                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                      // _isValidUrl = false;
                                      return  const Text(
                                        '圖片已過期',
                                        style: TextStyle(fontFamily:'abc',color: Colors.red),
                                        );
                                      },
                                    )
                                  )
                                ],
                              ):
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                              text,
                              style: TextStyle(
                                fontFamily: 'abc',
                                // Add a little line spacing to make the text look nicer when multilined.
                                height: 1.3,
                                color: isMine
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onPrimaryContainer,
                              ),
                              softWrap: true,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children:[
                                SizedBox(width: 120),
                                if(!isMine) IconButton(onPressed: (){
                                  Clipboard.setData(ClipboardData(text: text));
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('複製完成'),
                                      content: const Text(
                                          '訊息已複製到剪貼簿上'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                          },
                                          child: const Text('Okay'),
                                        ),
                                      ],
                                    ),
                                  );
                                }, icon: Icon(Icons.copy,size: 10.0))],
                            )])
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
