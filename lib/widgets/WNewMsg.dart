import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class WNewMsg extends StatefulWidget {
  @override
  _WNewMsgState createState() => _WNewMsgState();
}

class _WNewMsgState extends State<WNewMsg> {
  final _controller = TextEditingController();

  void _sendMsg(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();

    Firestore.instance.collection('chats').add({
      'userId': user.uid,
      'text': this._controller.text,
      'createdAt': Timestamp.now(),
    });

    this._controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(55),
              ),
              child: TextField(
                controller: this._controller,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Send a message...",
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none, 
                ),
                onChanged: (_) {
                  setState(() {});
                },
              ),
            ),
          ),

          SizedBox(width: 8,),

          FloatingActionButton(
            child: Icon(Icons.send),
            onPressed: () {
              if(this._controller.text.trim() == ""){
                return null;
              }else {
                this._sendMsg(context);
              }
            },
            backgroundColor: this._controller.text.trim() == ""
              ? Colors.grey
              : Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
