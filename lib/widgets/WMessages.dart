import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './WMessageBubble.dart';


class WMessages extends StatelessWidget {

  Widget _buildMsgsList(BuildContext ctx, AsyncSnapshot<dynamic> snapshot, dynamic msgs){
    if(snapshot.connectionState == ConnectionState.waiting){
      return Center(child: CircularProgressIndicator(),);
    }
    else{
      return ListView.builder(
        reverse: true,
        itemCount: msgs.length,
        itemBuilder: (_, index){
          return WMessageBubble(
            msgs[index]['text'],
            msgs[index]['sender'],
            msgs[index]['userId'] == snapshot.data.uid,
            key: ValueKey(msgs[index].documentID),
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
                final msgs = chatsSnapshot.data.documents;
                return this._buildMsgsList(context, authSnapshot, msgs);
              }
            },
          );
        }
      },
    );
  }
}