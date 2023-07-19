import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstday/screen/login_page.dart';
import 'package:firstday/Screens/upload_multiple_img.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'List_Page.dart';
import 'crud.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddPage();
  }
}

class _AddPage extends State<AddPage> {
  final employeeName = TextEditingController();
  final employeePosition = TextEditingController();
  final employeeContact = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      controller: employeeName,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        } else if (value.length < 4) {
          return 'The Must be at least 4 characters';
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );

    final positionField = TextFormField(
        controller: employeePosition,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Position",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final contactField = TextFormField(
      keyboardType: TextInputType.phone,
      controller: employeeContact,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        } else if (value.length < 11) {
          return 'The Contact Number must be at least 8 digits';
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Contact Number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );

    final viewListbutton = TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ListPage(),
            ),
            (route) => false, //To disable back feature set to false
          );
        },
        child: const Text('View List of Employee'));

    final SaveButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var response = await FirebaseCrud.addEmployee(
                name: employeeName.text,
                position: employeePosition.text,
                contactno: employeeContact.text);
            if (response.code != 200) {
              Fluttertoast.showToast(msg: response.message.toString(),);
            } else {
               Fluttertoast.showToast(msg: response.message.toString(),);
            }
          }
        },
        child: Text(
          "Save",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Employ Data'),
        backgroundColor: Colors.white.withOpacity(0.9),
        actions: [
          IconButton(icon:const Icon(Icons.logout), onPressed: () {
            auth.signOut().then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage(),),),).onError((error, stackTrace){
              Fluttertoast.showToast(msg: error.toString(),);
            });
          }, ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.04,
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  nameField,
                  const SizedBox(height: 25.0),
                  positionField,
                  const SizedBox(height: 35.0),
                  contactField,
                  viewListbutton,
                  const SizedBox(height: 45.0),
                  SaveButon,
                  const SizedBox(height: 15.0),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddImage()));
                    },
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.08,
                      width: MediaQuery.sizeOf(context).width /2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2),
                      ),
                      child: const Center(
                        child: Text("Upload Image",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
