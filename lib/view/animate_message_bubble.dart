import 'package:flutter/material.dart';
import 'package:final_project/view/message_bubble.dart';
class AnimatedMessage extends StatefulWidget {
  
  final bool isLast;

  // Image of the user to be displayed next to the bubble. Not required if the message is not the first in a sequence.

  // Username of the user.  Not required if the message is not the first in a sequence.
  final String? userName;
  final String text;

  // Controls how the MessageBubble will be aligned.
  final bool isMine;
  final bool isURL;
  final String memesUrl;

  AnimatedMessage.withUser({
    super.key,
    required this.userName,
    required this.text,
    required this.isMine,
    required this.isLast,
    required this.isURL,
    required this.memesUrl
  });

  // Create a amessage bubble that continues the sequence.
  AnimatedMessage({
    super.key,
    required this.text,
    required this.isMine,
    required this.isLast,
    required this.isURL,
    required this.memesUrl
  }):userName = null;

  @override
  _AnimatedMessageState createState() => _AnimatedMessageState();
}

class _AnimatedMessageState extends State<AnimatedMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(widget.isMine ? 1.0 : -1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation when the widget is built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: (widget.userName != null)?MessageBubble.withUser(
        text: widget.text,
        isLast: widget.isLast,
        isMine: widget.isMine,
        isURL: widget.isURL,
        memesUrl: widget.memesUrl,
        userName: widget.userName,
      )
      :MessageBubble(
        text: widget.text,
        isLast: widget.isLast,
        isMine: widget.isMine,
        isURL: widget.isURL,
        memesUrl: widget.memesUrl,
      )
    );
  }
}