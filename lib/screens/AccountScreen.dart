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
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Hi ${FirebaseHelper.instance.currentUser.email}',style: TextStyle(
              inherit: true,
              fontSize: 30.0,
              color: Colors.white,
              shadows: [
                Shadow( // bottomLeft
                    offset: Offset(-1.5, -1.5),
                    color: Colors.black45
                ),
                Shadow( // bottomRight
                    offset: Offset(1.5, -1.5),
                    color: Colors.black45
                ),
                Shadow( // topRight
                    offset: Offset(1.5, 1.5),
                    color: Colors.black45
                ),
                Shadow( // topLeft
                    offset: Offset(-1.5, 1.5),
                    color: Colors.black45
                ),

              ]
          ) ,textAlign: TextAlign.center,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: FlatButton(child: Text('Sign out'),color: Colors.blue, onPressed: (){
              FirebaseHelper.instance.signOutGoogle();
              FirebaseHelper.logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                return LoginPage();
              }));
              },),
          ),
        ],
      )
    );
  }
}