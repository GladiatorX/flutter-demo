import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ///////////////STEP 1: JSON parsing & Custom listview //////////////////////////
//TODO: https://www.melvinvivas.com/flutter-listview-example-using-data-from-a-rest-api/
//TODO: https://pusher.com/tutorials/flutter-listviews


class Job {
  final int id;
  final String position;
  final String company;
  final String description;

  Job({this.id, this.position, this.company, this.description});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      position: json['position'],
      company: json['company'],
      description: json['description'],
    );
  }
}


class AllComplaintList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Job> data = snapshot.data;
          return _jobsListView(data);// context
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
}

  Future<List<Job>> _fetchJobs() async {

    final jobsListAPIUrl = 'https://mock-json-service.glitch.me/';
    final response = await http.get(jobsListAPIUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(Icons.work,context,data[index]);
        });
  }
//11_ I just passed context variable in here for snackbar
  ListTile _tile(IconData icon,context,dataVal ) => ListTile(
    title: Text(dataVal.position,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(dataVal.company),
    leading: Icon(
      icon,
      color: Colors.blue[500],

    ),
    //Also can inculde trailing img or something.
    onTap: (){

      final snackBar = SnackBar(content: Text('Clicked '+dataVal.toString()));
      Scaffold.of(context).showSnackBar(snackBar);

      Fluttertoast.showToast(
          msg: " "+dataVal.position+" "+dataVal.company+" ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

//      Navigator.push(
//          context,
//          MaterialPageRoute(
//          builder: (context) => DetailComplaintScreen(),
//  settings: RouteSettings(
//  arguments: dataVal,
//  ),
//  ),
//      );
},
);


}
