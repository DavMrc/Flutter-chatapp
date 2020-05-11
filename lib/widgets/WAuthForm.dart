import "package:flutter/material.dart";


class WAuthForm extends StatefulWidget {
  final void Function({
    String username,
    String email,
    String password,
    bool isLogin
  }) submitAuthForm;

  WAuthForm(this.submitAuthForm);

  @override
  _WAuthFormState createState() => _WAuthFormState();
}

class _WAuthFormState extends State<WAuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;

  String _username = "";
  String _email = "";
  String _password = "";

  String _validate(String value, String type){
    if(type == "email"){
      if(!value.contains('@') ||
        !value.contains('.') ||
        value == null || value == ""
      ) return "Please provide a valid email";
      return null;
    }
    if(type == "username"){
      if(value == null || value == "") return "Please provide a valid username!";
      return null;
    }
    if(type == "pwd"){
      if(value == null || value == '') return "Please provide a valid password!";
      else if(value.length < 8) return "The password should be at least eight characters long!";
      return null;
    }
  }

  void _login(){
    if(this._formKey.currentState.validate()){
      this._formKey.currentState.save();

      FocusScope.of(context).unfocus();  // hides the softkey

      this.widget.submitAuthForm(
        email: this._email,
        password: this._password,
        isLogin: this._isLogin,
      );
    }
  }

  void _signup(){
    if(this._formKey.currentState.validate()){
      this._formKey.currentState.save();

      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this._formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,  // takes as much space as strictly needed
        children: [
          if(!this._isLogin)
          TextFormField(
            key: ValueKey('username'),
            decoration: InputDecoration(
              labelText: "Username",
            ),
            validator: (value) => this._validate(value, 'username'),
            onSaved: (newValue) => this._username = newValue,
          ),
          
          TextFormField(
            key: ValueKey('email'),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email address",
            ),
            validator: (value) => this._validate(value, 'email'),
            onSaved: (newValue) => this._email = newValue,
          ),

          TextFormField(
            key: ValueKey('password'),
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password"
            ),
            validator: (value) => this._validate(value, 'pwd'),
            onSaved: (newValue) => this._password = newValue,
          ),

          SizedBox(height: 15,),

          RaisedButton(
            child: this._isLogin ? Text("Login") : Text("Create new account"),
            onPressed: this._isLogin ? this._login : this._signup,
          ),

          FlatButton(
            child: this._isLogin ? Text("Create new account") : Text("Login"),
            textColor: Theme.of(context).primaryColor,
            onPressed: (){
              setState(() {
                this._isLogin = ! this._isLogin;
              });
            },
          ),
        ],
      ),
    );
  }
}