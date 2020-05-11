import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SChat extends StatelessWidget {
  static const routeName = "/chat";
  static const msgsCollection = 'chats/Ka5W8FF8IUVaGbeukU6C/messages';

  Widget onFSValue(AsyncSnapshot<dynamic> snapshot){
    if(snapshot.connectionState == ConnectionState.waiting){
      return Center(child: CircularProgressIndicator(),);
    }

    final documents = snapshot.data.documents;
  
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (_, index) => Container(
        padding: const EdgeInsets.all(8),
        child: Text(documents[index]['text']),
      ),
    );
  }

  void addMessage(){
    Firestore.instance.collection(SChat.msgsCollection).add({
      'text': "This was added by clicking the button!"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection(SChat.msgsCollection).snapshots(),  // autonotified listener
        builder: (_, snapshot) => this.onFSValue(snapshot),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => this.addMessage(),
      ),
    );
  }
}