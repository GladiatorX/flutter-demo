
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class AddComplaint extends StatefulWidget {

  @override
  _AddComplaintState createState() => _AddComplaintState();
}
class _AddComplaintState extends State<AddComplaint> {

  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  //TODO Encapsulated scafold in material app, on submit its not retunng img as dict item, for POST req.
  Future<File> imageFile;

  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          title: Text("Post a Complaint"),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FormBuilder(
                  key: _fbKey,
                  initialValue: {
                    'date': DateTime.now(),
                    'accept_terms': false,
                  },
                  autovalidate: true,
                  child: Column(
                    children: <Widget>[

                      FutureBuilder<File>(
                        future: imageFile,
                        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done &&
                              snapshot.data != null) {
                            return Image.file(
                              snapshot.data,
                              width: 200,
                              height: 200,
                            );
                          } else if (snapshot.error != null) {
                            return const Text(
                              'Error Picking Image',
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return const Text(
                              'No Image Selected',
                              textAlign: TextAlign.center,
                            );
                          }
                        },
                      ),

                      RaisedButton(

                        child: Text("Select Image from Gallery"),
                        onPressed: () {
                          pickImageFromGallery(ImageSource.gallery);
                        },
                      ),

                      FormBuilderTextField(
                        attribute: 'complain_title',
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Complaint Title"),
                      ),

                      FormBuilderTextField(
                        attribute: 'complain_description',
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Complaint Description"),
                      ),

                      FormBuilderTextField(
                        attribute: "number",
                        decoration: InputDecoration(labelText: "Number"),
                        keyboardType: TextInputType.number,
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.maxLength(10),
                        ],
                      ),

                      FormBuilderTextField(
                        attribute: 'taluka',
                        validators: [FormBuilderValidators.required()],
                        readOnly: true,
                        initialValue: "Ponda",
                        decoration: InputDecoration(labelText: "Taluka"),
                      ),

                      FormBuilderTextField(
                        attribute: 'village',
                        validators: [FormBuilderValidators.required()],
                        readOnly: true,
                        initialValue: "borim",
                        decoration: InputDecoration(labelText: "Village"),
                      ),

                      FormBuilderSegmentedControl(
                        decoration: InputDecoration(labelText: "Severity"),
                        attribute: "complain_severity",
                        options: List.generate(5, (i) => i + 1)
                            .map(
                                (number) => FormBuilderFieldOption(value: number))
                            .toList(),
                      ),


                      FormBuilderCheckboxList(
                        decoration:
                        InputDecoration(labelText: "Languages you know"),
                        attribute: "languages",
                        initialValue: ["English"],
                        options: [
                          FormBuilderFieldOption(value: "English"),
                          FormBuilderFieldOption(value: "Hindi"),
                          FormBuilderFieldOption(value: "Other")
                        ],
                      ),
                      FormBuilderCheckbox(
                        attribute: 'accept_terms',
                        label: Text(
                            "I have read and agree to the terms and conditions"),
                        validators: [
                          FormBuilderValidators.requiredTrue(
                            errorText:
                            "You must accept terms and conditions to continue",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    MaterialButton(
                      child: Text("Submit"),
                      onPressed: () {
                        _fbKey.currentState.save();
                        if (_fbKey.currentState.validate()) {
                          print(_fbKey.currentState.value);
                          //_makePostRequest();
                        }
                      },
                    ),
                    MaterialButton(
                      child: Text("Reset"),
                      onPressed: () {
                        _fbKey.currentState.reset();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
//TODO: https://medium.com/swlh/how-to-make-http-requests-in-flutter-d12e98ee1cef
_makePostRequest() async {
  // set up POST request arguments
  String url = 'https://jsonplaceholder.typicode.com/posts';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"title": "Hello", "body": "body text", "userId": 1}';
  //using encoding
  //TODO:https://stackoverflow.com/questions/53792081/flutter-post-request-body-not-sent
  // make POST request
  Response response = await post(url, headers: headers, body: json);
  // check the status code for the result
  //TODO: https://stackoverflow.com/questions/51362777/how-to-make-a-post-request-in-a-flutter-for-web-api
  final int statusCode = response.statusCode;
  if (statusCode < 200 || statusCode > 400 || json == null) {
    throw new Exception("Error while fetching data");
  }
  // this API passes back the id of the new item added to the body
  String body = response.body;
  print("body "+body);
  // {
  //   "title": "Hello",
  //   "body": "body text",
  //   "userId": 1,
  //   "id": 101
  // }
}