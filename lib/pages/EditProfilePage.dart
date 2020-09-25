import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/pages/ProfilePage.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';

class EditProfilePage extends StatefulWidget {
  final String currentOnlineUserId;

  EditProfilePage({this.currentOnlineUserId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController profileNameTextEdittingController = TextEditingController();
  TextEditingController bioTextEdittingController = TextEditingController();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  User user;
  bool _profileNameValid = true;
  bool _bioValid = true;

   void initState(){
   super.initState();
   getAndDisplayUserInformation();
   }

  getAndDisplayUserInformation() async{
     setState(() {
       loading = true;
     });
     DocumentSnapshot documentSnapshot =await usersReference.document(widget.currentOnlineUserId).get();
     user = User.fromDocument(documentSnapshot);
     profileNameTextEdittingController.text = user.profileName;
     bioTextEdittingController.text = user.bio;
     setState(() {
       loading = false;
     });
  }


  updateUserData(){
    setState(() {
      profileNameTextEdittingController.text.trim().length < 3 || profileNameTextEdittingController.text.isEmpty ? _profileNameValid = false :_profileNameValid = true;
     bioTextEdittingController.text.trim().length>110 ? _bioValid = false : _bioValid = true;
    });
    if(_bioValid && _profileNameValid){
      usersReference.document(widget.currentOnlineUserId).updateData({
        "profileName":profileNameTextEdittingController.text,
        "bio": bioTextEdittingController.text,
      });
      SnackBar successSnackBar = SnackBar(content: Text("Profile has been updated successfully"),);
      _scaffoldGlobalKey.currentState.showSnackBar(successSnackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Edit Profile",
        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        actions: [
          IconButton(icon: Icon(Icons.done, color: Colors.white,size: 30.0,), onPressed:()=> Navigator.push(context,MaterialPageRoute(builder: (context)=> HomePage() )),),
        ],
      ),
      body: loading ? circularProgress(): ListView(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.0,bottom: 8.0),
                  child: CircleAvatar(
                    radius: 52.0,
                    backgroundImage: CachedNetworkImageProvider(user.url)
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      createProfileNameTextFormField(), createBioTextFormField()
                    ],
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(top: 29.0,left: 50.0, right: 50.0) ,
                  child: RaisedButton(
                    color: Colors.green,
                    onPressed: updateUserData,
                    child: Text(
                      "     update     ",
                      style: TextStyle(color: Colors.black,fontSize: 16.0),
                    ),
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(top: 10.0,left: 50.0, right: 50.0) ,
                  child: RaisedButton(
                    color: Colors.red,
                    onPressed: logoutUser,
                    child: Text(
                      "LogOut",
                      style: TextStyle(color: Colors.white,fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  logoutUser() async {
   await gSignIn.signOut();
   Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
  }

   Column createProfileNameTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 13.0),
          child: Text(
            "Profile Name",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          style: TextStyle(
              color: Colors.white
          ),
          controller: profileNameTextEdittingController,
          decoration: InputDecoration(
              hintText: " Write Profile name here..",
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
              ),
              hintStyle: TextStyle(color: Colors.grey),
              errorText: _profileNameValid ? null : "Profile name is too short"
          ),
        ),
      ],
    );
  }

  Column createBioTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 13.0),
          child: Text(
            "Bio",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          style: TextStyle(
              color: Colors.white
          ),
          controller: bioTextEdittingController,
          decoration: InputDecoration(
              hintText: " Write Bio here..",
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
              ),
              hintStyle: TextStyle(color: Colors.grey),
              errorText: _bioValid ? null : "Bio name is too long"
          ),
        ),
      ],
    );
  }

}
