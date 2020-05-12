import 'package:flutter/material.dart';


class WMessageBubble extends StatelessWidget {
  final String _text;
  final bool _isThisUser;
  final Key key;

  WMessageBubble(this._text, this._isThisUser, {this.key});

  @override
  Widget build(BuildContext context) {
    UserStyle userStyle = UserStyle(context, _isThisUser);

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

          child: Text(
            this._text,
            style: TextStyle(
              fontSize: 16,
              color: userStyle.textColor,
            ),
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

  Color get textColor{
    return this._isThisUser
      ? Theme.of(context).primaryTextTheme.headline6.color
      : Theme.of(context).textTheme.headline5.color;
  }
}