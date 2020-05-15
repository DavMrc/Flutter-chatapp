import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/WMessageBubble.dart';
import '../widgets/WNewMsg.dart';


class SChat extends StatelessWidget {
  static const routeName = "/chat";
  String _contactId;

  Widget _buildMsgs(BuildContext context, AsyncSnapshot<dynamic> snapshot){
    if(snapshot.hasData){
      final msgs = snapshot.data.documents as List<DocumentSnapshot>;

      if(msgs.isEmpty){
        return WNoMsgs();
      }

      return ListView.builder(
        reverse: true,
        itemCount: msgs.length,
        itemBuilder: (_, index){
          return WMessageBubble(
            msgs[index]['text'],
            msgs[index]['sender'],
            msgs[index]['userImage'],
            msgs[index]['userId'] != this._contactId,
            key: ValueKey(msgs[index].documentID),
          );
        }
      );
    }
    else{
      return Center(child: CircularProgressIndicator(),);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    this._contactId = (routeArgs['contactDocumentSnapshot'] as DocumentSnapshot).documentID;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(routeArgs['contactDocumentSnapshot']['imageUrl']),
            ),
            SizedBox(width: 10,),
            Text(routeArgs['contactDocumentSnapshot']['username']),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: Firestore.instance
                .collection('chat')
                .document(routeArgs['chatPath'])
                .collection('msgs')
                .snapshots(),
              builder: (context, snapshot) => this._buildMsgs(context, snapshot),
            ),
          ),

          WNewMsg('chat', routeArgs['chatPath']),
        ],
      ),
    );
  }
}


class WNoMsgs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Chip(
        label: Text(
          "You guys have no msgs!",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}