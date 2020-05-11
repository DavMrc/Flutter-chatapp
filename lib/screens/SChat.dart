import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SChat extends StatelessWidget {

  Widget onFSValue(AsyncSnapshot<dynamic> snapshot){
    final documents = snapshot.data.documents;

    if(snapshot.connectionState == ConnectionState.waiting){
      return Center(child: CircularProgressIndicator(),);
    }
  
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (_, index) => Container(
        padding: const EdgeInsets.all(8),
        child: Text(documents[index]['text']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String path = 'chats/Ka5W8FF8IUVaGbeukU6C/messages';

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(""),
      // ),
      body: StreamBuilder(
        stream: Firestore.instance.collection(path).snapshots(),  // autonotified listener
        builder: (_, snapshot) => this.onFSValue(snapshot),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){},
      ),
    );
  }
}