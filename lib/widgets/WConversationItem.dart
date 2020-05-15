import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/SChat.dart';


class WConversationItem extends StatelessWidget {
  final DocumentSnapshot _contactFullData;

  WConversationItem(this._contactFullData);

  Future<void> _goToPrivateChat(BuildContext context) async{
    final currentUser = await FirebaseAuth.instance.currentUser();
    var chatPath = "${currentUser.uid}_${_contactFullData.documentID}";

    var chat = await Firestore.instance.collection('chat')
      .document(chatPath).collection('msgs').getDocuments();
    
    if(chat.documents.isNotEmpty){
      Navigator.of(context).pushNamed(
        SChat.routeName,
        arguments: {
          'chatPath': chatPath,
          'contactDocumentSnapshot': _contactFullData
        },
      );
    }
    else{
      chatPath = "${_contactFullData.documentID}_${currentUser.uid}";
      chat = await Firestore.instance.collection('chat')
        .document(chatPath).collection('msgs').getDocuments();

      Navigator.of(context).pushNamed(
        SChat.routeName,
        arguments: {
          'chatPath': chatPath,
          'contactDocumentSnapshot': _contactFullData
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(this._contactFullData['imageUrl']),
          radius: 25,
        ),
        title: Text(
          this._contactFullData['username'],
          style: const TextStyle(
            fontSize: 20
          ),
        ),
        onTap: () => this._goToPrivateChat(context),  // go to private chat
      ),
    );
  }
}