import 'package:buddiesgram/pages/NotificationsPage.dart';
import 'package:buddiesgram/pages/ProfilePage.dart';
import 'package:buddiesgram/pages/SearchPage.dart';
import 'package:buddiesgram/pages/TimeLinePage.dart';
import 'package:buddiesgram/pages/UploadPage.dart';
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
  PageController pageController;
  int getPageIndex = 0;
  void initState(){
  super.initState();
  gSignIn.onCurrentUserChanged.listen((gSigninAccount){
    controlSignIn(gSigninAccount);
  }, onError:(gError){
    print("Error Message: " +gError);
  });

  gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount){
    controlSignIn(gSignInAccount);
  }).catchError((gError) {
    print("Error Message: " + gError);
  });
  }
  controlSignIn(GoogleSignInAccount signInAccount) async {
    if(signInAccount != null)
      {
        setState(() {
          isSignedIn =true;
        });
      } else{
      setState(() {
        isSignedIn = false;
      });
    }
  }
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  loginUser() {
    gSignIn.signIn();
  }

  logoutUser(){
    gSignIn.signOut();
  }
  whenPageChanges(int pageIndex){
   setState(() {
     this.getPageIndex = pageIndex;
   });
  }

onTapChangePage(int pageIndex  ){
  setState(() {
    this.getPageIndex = pageIndex;
  });
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 400),
        curve: Curves.bounceInOut,);
}

  Scaffold buildHomeScreen(){
    return Scaffold(
      body: PageView(
        children: [
          TimeLinePage(),
          SearchPage(),
          UploadPage(),
          NotificationsPage(),
          ProfilePage(),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapChangePage,
        backgroundColor: Theme.of(context).accentColor,
        activeColor: Colors.white,
        inactiveColor: Colors.blueGrey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,)),
          BottomNavigationBarItem(icon: Icon(Icons.search,)),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera,size: 37.0,)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite,)),
          BottomNavigationBarItem(icon: Icon(Icons.person,)),
        ],
      ),
    );
    // return RaisedButton.icon(onPressed: logoutUser, icon: Icon(
    //   Icons.person_pin
    // ), label: Text("Sign Out"));
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
