import 'package:flutter/material.dart';
import 'package:pod_cast_app/screens/LoginPage.dart';
import 'package:pod_cast_app/service/FirebaseHelper.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Screen"),

      ),
      body:Center(child: IconButton(icon: Icon(Icons.not_interested),onPressed: (){
        FirebaseHelper.instance.signOutGoogle();
        FirebaseHelper.logout();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
          return LoginPage();
        }));
        },),)
    );
  }
}