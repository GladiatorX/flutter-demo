import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Complaint {
  final int userId;
  final int id;
  final String title;
  final String body;

  Complaint({this.userId, this.id, this.title, this.body});

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

/////////////// STEP 2 : Additional Step for handling connectivity//////////////////////////
// TODO OR use this https://www.youtube.com/watch?v=u_Xyqo6lhFE
/// requires stateful widget
//TODO: https://github.com/iampawan/flutter_connectivity/blob/master/lib/main.dart
class MyComplaintList extends StatefulWidget {
  @override
  _MyComplaintState createState() => new _MyComplaintState();
}

class _MyComplaintState extends State<MyComplaintList> {

  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          _connectionStatus = result.toString();
          print(_connectionStatus);
          if (result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile) {
            setState(() {});
          }else{
            AwesomeDialog(context: context,
                dialogType: DialogType.WARNING,
                animType: AnimType.BOTTOMSLIDE,
                tittle: 'No Internet',
                desc: "Data can't be fetched!",
                //btnCancelOnPress: () {},
                btnOkOnPress: () {
              print("Dismiss kar");
                }).show();


          }
        });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

//////////////////////////////////////////////////////////////////////

  Widget build(BuildContext context) {
    return FutureBuilder<List<Complaint>>(
      future: _fetchMyComplaint(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Complaint> data = snapshot.data;
          return _ComplaintListView(data); // context
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Complaint>> _fetchMyComplaint() async {

    final response =    await http.get('https://jsonplaceholder.typicode.com/posts');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((complaint) => new Complaint.fromJson(complaint)).toList();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

    ListView _ComplaintListView(data) {
      return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return _tile(data[index],  context);
          });
    }


  ListTile _tile(dataVal,context ) => ListTile(
    title: Text(dataVal.title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(dataVal.body),
//    leading: Icon(
//      icon,
//      color: Colors.blue[500],
//
//    ),
    onTap: (){

      final snackBar = SnackBar(content: Text('Clicked '+dataVal.id.toString()));
      Scaffold.of(context).showSnackBar(snackBar);

      Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => DetailComplaintScreen(),
          settings: RouteSettings(
          arguments: dataVal,
          ),
          ),
          );


    },
  );



}
/////// THis is new class//////////
// import MyComplaintList as data model is defined there


class DetailComplaintScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Complaint compl = ModalRoute.of(context).settings.arguments;

    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(compl.title+" "+compl.id.toString()),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(compl.body),
      ),
    );
  }
}


