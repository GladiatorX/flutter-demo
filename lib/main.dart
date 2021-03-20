import 'package:flutter/material.dart';
import 'package:flutter_app1/AddComplaint.dart';
import 'package:flutter_app1/Network/AllComplaintList.dart';
import 'package:flutter_app1/Network/MyComplaintList.dart';

import 'package:flutter_app1/menu/overflowmenu.dart';




//TODO: only when theres single page
//void main() => runApp(TabBarDemo());//MyApp()
//TODO: Do it this way when there is multiple page n route
void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: TabBarDemo(),
  ));
}

class TabBarDemo extends StatelessWidget {
  //TODO : https://flutter.dev/docs/cookbook/design/tabs
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(text: "All Complaint"),
                  Tab(text: "My Complaint"),
                  //Tab(icon: Icon(Icons.directions_bike)),
                ],
              ),
              title: Text('Tabs Demo'),
              actions: <Widget>[
                PopupMenuButton<String>(
                  //onSelected: _choiceAction,
                  onSelected: _choiceAction,
                  itemBuilder: (BuildContext context){
                    return Constants.choices.map((String choice){
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                )
              ],
            ),
            body: TabBarView(
              children: [
                new AllComplaintList(),//Icon(Icons.directions_car),
                new MyComplaintList()//Icon(Icons.directions_transit),
                //Icon(Icons.directions_bike),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              //onPressed: _navigateToNextScreen(context),
              onPressed: () {
                print("Clicked");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddComplaint()),
                );
              },
              tooltip: 'New Complaint',
              child: Icon(Icons.add),
            )
        ),
      ),
    );
  }



  //11 Handle Oveflow menu here
  void _choiceAction(String choice){
    if(choice == Constants.Settings){
      print('Settings');
    }else if(choice == Constants.Subscribe){
      print('Subscribe');
    }
    else if(choice == Constants.SignOut){
      print('SignOut');
      AlertDialog(
        title: Text("Sign Out?"),
        content: Text("Are you sure?"),
//        actions: [
//          FlatButton("No"),
//          FlatButton("yes"),
//        ],

      );
      print('SignOut==');

    }
  }


}


//class SecondRoute extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Second Route"),
//      ),
//      body: Center(
//        child: RaisedButton(
//          onPressed: () {
//            Navigator.pop(context);
//          },
//          child: Text('Go back!'),
//        ),
//      ),
//    );
//  }
//}

