import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './WMessageBubble.dart';


class WMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('chats')
        .orderBy('createdAt', descending: true)
        .snapshots(),
      builder: (_, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        else{
          final docs = snapshot.data.documents;
          return ListView.builder(
            reverse: true,
            itemCount: docs.length,
            itemBuilder: (_, index){
              return WMessageBubble(docs[index]['text']);
            }
          );
        }
      },
    );
  }
}