import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn gSignIn = GoogleSignIn();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSignedIn = false;

  loginUser() {
    gSignIn.signIn();
  }

  Widget buildHomeScreen(){
    return Text('already signed in');
  }

  Scaffold buildSignInScreen(){
    return Scaffold(
      body:Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end:  Alignment.bottomLeft,
            colors:[Theme.of(context).accentColor,Theme.of(context).primaryColor]

          )
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('instagram',
              style: TextStyle(fontSize:92 ,color: Colors.white,fontFamily: "Signatra"),),
            GestureDetector(
              onTap: ()=> loginUser(),
              child: Container(
                width: 270,
                height: 65,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google_signin_button.png'),
                    fit: BoxFit.cover,
                  )
                ),
              ),
            ),

          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
   if(isSignedIn)
     {
     return buildHomeScreen();
     } else {
     return buildSignInScreen();
   }
  }
}
