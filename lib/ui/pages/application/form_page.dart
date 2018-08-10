import 'package:flutter/material.dart';
import 'package:flutter_office/ui/widget.dart';

class FormPage extends StatefulWidget {
  final globalKey = new GlobalKey<FormState>(debugLabel: "form_application");

  @override
  FormPageState createState() {
    return new FormPageState();
  }
}

class FormPageState extends State<FormPage> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.ac_unit), title: Text("SNOW")),
          BottomNavigationBarItem(
              icon: new Icon(Icons.audiotrack), title: Text("MUSIC"))
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: new ApplicationForm(widget.globalKey),
    );
  }
}

class ApplicationForm extends StatefulWidget {
  final GlobalKey<FormState> globalKey;

  ApplicationForm(this.globalKey);

  @override
  State createState() => new ApplicationFormState();
}

class ApplicationFormState extends State<ApplicationForm> {
  @override
  Widget build(BuildContext context) {
    return new Form(
      key: widget.globalKey,
      child: Column(
        children: <Widget>[
          new TextFormField(
            initialValue: "1",
            // The validator receives the text the user has typed in
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
          RaisedButton(
            onPressed: () {
              // Validate will return true if the form is valid, or false if
              // the form is invalid.
              if (widget.globalKey.currentState.validate()) {
                // If the form is valid, we want to show a Snackbar
                Scaffold
                    .of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
                widget.globalKey.currentState.save();
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
