import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class WMessageBubble extends StatelessWidget {
  final String _text;
  final String _userId;
  final bool _isThisUser;
  final Key key;

  WMessageBubble(this._text, this._userId, this._isThisUser, {this.key});

  Widget _fetchUserName(AsyncSnapshot<dynamic> snapshot, UserStyle userStyle){
    if(snapshot.connectionState == ConnectionState.waiting){
      return Text("...");
    }else if (snapshot.connectionState == ConnectionState.done){
      return Container(
        margin: const EdgeInsets.only(bottom: 5),
        // padding: const EdgeInsets.only(bottom: 1),   // adds extra spacing between underline and text
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(
            color: userStyle.usernameColor,
            width: 1.5, // Underline width
          ))
        ),

        child: Text(
          snapshot.data['username'],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: userStyle.usernameColor,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    UserStyle userStyle = UserStyle(context, this._isThisUser);

    return Row(
      mainAxisAlignment: userStyle.msgAlignment,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.55,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: userStyle.boxColor,
            borderRadius: userStyle.borderRadius,
            border: Border.all(
              width: 2,
              color: userStyle.borderColor
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: Firestore.instance.collection('users').document(this._userId).get(),
                builder: (_, snapshot)  => this._fetchUserName(snapshot, userStyle)
              ),
              Text(
                this._text,
                style: TextStyle(
                  fontSize: 16,
                  color: userStyle.contentColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class UserStyle{
  final BuildContext context;
  final bool _isThisUser;
  final defaultRadius = Radius.circular(15);

  UserStyle(this.context, this._isThisUser);

  MainAxisAlignment get msgAlignment{
    return this._isThisUser
      ? MainAxisAlignment.end
      : MainAxisAlignment.start;
  }

  Color get boxColor{
    return this._isThisUser
      ? Theme.of(context).accentColor.withOpacity(0.65)
      : Theme.of(context).secondaryHeaderColor.withOpacity(0.65);
  }

  BorderRadiusGeometry get borderRadius{
    return this._isThisUser
      ? BorderRadius.only(topRight: defaultRadius, topLeft: defaultRadius, bottomLeft: defaultRadius)
      : BorderRadius.only(topRight: defaultRadius, topLeft: defaultRadius, bottomRight: defaultRadius);
  }

  Color get borderColor{
    return this._isThisUser
      ? Theme.of(context).accentColor
      : Theme.of(context).secondaryHeaderColor;
  }

  Color get contentColor{
    return this._isThisUser
      ? Theme.of(context).primaryTextTheme.headline6.color
      : Theme.of(context).textTheme.headline5.color;
  }

  Color get usernameColor{
    return this._isThisUser
      ? Theme.of(context).secondaryHeaderColor
      : Theme.of(context).accentColor;
  }
}