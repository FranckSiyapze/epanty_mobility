import 'package:epanty_mobility/model/chat_params.dart';
import 'package:flutter/material.dart';
import 'chat.dart';

class ChatScreen extends StatelessWidget {
  final ChatParams chatParams;

  const ChatScreen({Key? key, required this.chatParams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0.0,
          title: Text('Chat with ' + chatParams.peer.name)
      ),
      body: Text('tete'),
    );
  }
}
