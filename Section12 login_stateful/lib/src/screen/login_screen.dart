import 'package:flutter/material.dart';
import '../validation/validation_mxin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget{
  createState(){
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> with validationMixin{

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser myuser;

  bool isLogin = false;

  Future<FirebaseUser> _loginWithFacebook() async {

    final facebookLogin = new FacebookLogin();

    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

    final result = await facebookLogin.logInWithReadPermissions(['email']);

    FirebaseUser user = await _auth.signInWithFacebook(accessToken: result.accessToken.token);
    
    return user;
  }

  void _logIn(){
    _loginWithFacebook().then((onValue){
      if (onValue != null) {
        print('logined $onValue');
        myuser = onValue;
        setState(() {
          isLogin = true;
        });
      } else {
        print('Error');
      }
    });
  }

  final formKey = GlobalKey<FormState>();
  
  String email, password;
  
  Widget build(context){
    return Container(
      margin: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
      child: Form(
        key: formKey,
        child: isLogin == false ? Column(
          children: [
              emailField(),
              passwordField(),
              new Container(margin: EdgeInsets.only(top: 20.0),),
              submitButton(),
              new Container(margin: EdgeInsets.only(top: 20.0),),
              facebookButton(),
          ],
        ) : Column(
          children: <Widget>[
            Center( 
              child: Column(
                children: <Widget>[
                  new Container(margin: EdgeInsets.only(top: 50.0),),
                  CircleAvatar(
                    backgroundImage: NetworkImage('${myuser.photoUrl}'),
                    minRadius: 30.0,
                    maxRadius: 30.0,
                  ),
                  new Container(margin: EdgeInsets.only(top: 20.0),),
                  Text(myuser.displayName,style: TextStyle(color: Colors.white),)
                ],
              ),
            ),
            new Container(margin: EdgeInsets.only(top: 20.0),),
            logoutButton(),
          ],
        )
      )
    );
  }

  Widget emailField(){
    return TextFormField(
      validator: validationEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        icon: Icon(Icons.email, color: Colors.white,),
        labelText: 'Email',
        // hintText: 'example@email.com',
        hintStyle: TextStyle(fontSize: 18.0, color: Colors.white),
        labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
        border: new UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white,width: 1.0, style: BorderStyle.none),
        )
      ),
      onSaved: (String value){
        print(value);
      },
      style: TextStyle( color: Colors.white),
    );
  }

  Widget passwordField(){
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.vpn_key, color: Colors.white,),
        labelText: 'Password',
        hintStyle: TextStyle(fontSize: 18.0, color: Colors.white),
        labelStyle: TextStyle(fontSize: 18.0, color: Colors.white)
      ),
      validator: validationPassword,
      onSaved: (String value){
        print(value);
      },
    );
  }

  Widget submitButton(){
    return RaisedButton(
      color: Colors.blueAccent,
      child: Text('Login'),
      textColor: Colors.white,
      shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      onPressed: () {
        if(formKey.currentState.validate()){
          formKey.currentState.save();
          formKey.currentState.reset();
        }
        // formKey.currentState.reset();
      },
    );
  }

  Widget logoutButton(){
    return RaisedButton(
      child: Icon(Icons.power_settings_new,color: Colors.red,),
      onPressed: () { logOut(); },
    );
  }
  
  Widget facebookButton(){
    return FacebookSignInButton(
      onPressed: () {
        _logIn();
      },
    );
  }
  
  Future<void> logOut() async {
    FacebookLogin.channel.invokeMethod('logOut');
    setState(() { isLogin = false;});
  } 

}

