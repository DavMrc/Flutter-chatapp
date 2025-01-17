import 'package:flutter/material.dart';


class WMessageBubble extends StatelessWidget {
  final String _msgContent;
  final String _userName;
  final String _userImageUrl;
  final bool _isThisUser;
  final Key key;

  WMessageBubble(this._msgContent, this._userName, this._userImageUrl, this._isThisUser, {this.key});

  @override
  Widget build(BuildContext context) {
    UserStyle userStyle = UserStyle(context, this._isThisUser);

    return Row(
      mainAxisAlignment: userStyle.msgAlignment,
      children: [
        Container(  // message "bubble" background
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
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(  // user img and name
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(this._userImageUrl),
                    ),

                    SizedBox(width: 10,),

                    Container(
                      // padding: const EdgeInsets.only(bottom: 1),   // adds extra spacing between underline and text
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(
                          color: userStyle.usernameColor,
                          width: 0.8, // Underline width
                        ))
                      ),

                      child: Text(
                        this._userName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: userStyle.usernameColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.55,
                  minWidth: 0,
                ),
                child: Text(  // msg content
                  this._msgContent,
                  style: TextStyle(
                    fontSize: 16,
                    color: userStyle.contentColor,
                  ),
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