
import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage> {
  TextEditingController searchTextEdittingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;
  emptyTheTextFormField(){
    searchTextEdittingController.clear();
  }
  controlSearching(String str){
    Future<QuerySnapshot> allUsers =
    usersReference.where("profileName", isGreaterThanOrEqualTo: str).getDocuments();
    setState(() {
      futureSearchResults = allUsers;
    });
  }

   AppBar searchPageHeader(){
     return AppBar(
       backgroundColor: Colors.black,
       title: TextFormField(
         style: TextStyle(fontSize: 18.0,color: Colors.white),
         controller: searchTextEdittingController,
         decoration: InputDecoration(
           hintText: "search here...",
           hintStyle: TextStyle(color: Colors.grey),
           enabledBorder: UnderlineInputBorder(
             borderSide: BorderSide(color: Colors.white),
           ),
           filled: true,
           prefixIcon: Icon(Icons.person_pin,color: Colors.white,size: 30.0,),
           suffixIcon: IconButton(icon: Icon(Icons.clear,color: Colors.white,),
             onPressed: emptyTheTextFormField,)

         ),
         onFieldSubmitted: controlSearching,
       ),
     );
   }
Container displayNoSearchResultScreen(){
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(Icons.group,color: Colors.grey,size: 200.0, ),
            Text("Search users",
            textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200,fontSize: 65.0),
            )
          ],
        ),
      ),
    );
}

  displayUsersFoundScreen(){
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context,dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress();
        }
        List<UserResult> searchUsersResult = [];
        dataSnapshot.data.documents.forEach((document){
          User eachUser = User.fromDocument(document);
          UserResult userResult = UserResult(eachUser);
          searchUsersResult.add(userResult);
        });
        return ListView(
          children: searchUsersResult
        );
      },
    );
  }
bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: searchPageHeader(),
      body: futureSearchResults == null ? displayNoSearchResultScreen() : displayUsersFoundScreen(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User eachUser;
  UserResult(this.eachUser);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white54,
        child: Column(
          children: [
            GestureDetector(
              onTap: () => print("tapped"),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: CachedNetworkImageProvider(eachUser.url),
                ),
                title: Text(eachUser.profileName,style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),),
                subtitle: Text(eachUser.username, style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.0
                ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
