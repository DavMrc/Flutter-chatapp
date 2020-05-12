import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './WMessageBubble.dart';


class WMessages extends StatelessWidget {

  Widget _buildMsgsList(BuildContext ctx, AsyncSnapshot<dynamic> snapshot, dynamic docs){
    if(snapshot.connectionState == ConnectionState.waiting){
      return Center(child: CircularProgressIndicator(),);
    }
    else{
      return ListView.builder(
        reverse: true,
        itemCount: docs.length,
        itemBuilder: (_, index){
          return WMessageBubble(
            docs[index]['text'],
            docs[index]['userId'] == snapshot.data.uid,
            key: ValueKey(docs[index].documentID),
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (_, authSnapshot) {
        if(authSnapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        // current user data ready, build the msgs using a streambuilder
        else if(authSnapshot.connectionState == ConnectionState.done){
          return StreamBuilder(
            stream: Firestore.instance.collection('chats')
              .orderBy('createdAt', descending: true)
              .snapshots(),

            builder: (_, chatsSnapshot) {
              if(chatsSnapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              else{
                final docs = chatsSnapshot.data.documents;
                return this._buildMsgsList(context, authSnapshot, docs);
              }
            },
          );
        }
      },
    );
  }
}