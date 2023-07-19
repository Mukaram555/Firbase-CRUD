import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstday/Screens/ImagesScreen.dart';
import 'package:flutter/material.dart';
import '../models/employModel.dart';
import 'crud.dart';
import 'edit.dart';
import 'homePage.dart';

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListPage();
  }
}

class _ListPage extends State<ListPage> {
  final Stream<QuerySnapshot> collectionReference = FirebaseCrud.readEmployee();
  final searchFilter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("List of Employee"),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddPage()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.app_registration,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => AddPage(),
                ),
                (route) =>
                    true, //if you want to disable back feature set to false
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Search...',
              ),
              onChanged: (val){
                setState(() {
                });
              },
              onTap: (){
                // SearchScreen();
    },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: collectionReference,
              builder: (context, snapshot) {
                final CollectionReference title = fireStore.collection('Employee');
                if (snapshot.hasData) {
                  if (searchFilter.text.isEmpty)     {
                    return Padding(
                      padding:const  EdgeInsets.only(top: 8.0),
                      child: ListView(
                        children: snapshot.data!.docs.map((e) {
                          return Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Container(
                                    child: Row(
                                      children: [
                                        Text("Name: " + e["employee_name"]),
                                        Container(
                                          width: 100,
                                          height: 100,
                                          // child: Image.network(e['url']),
                                        )
                                      ],
                                    ),
                                  ),
                                  subtitle: Container(
                                    child: (Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Position: " + e['position'],
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        Text(
                                            "Contact Number: " +
                                                e['contact_no'],
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      ],
                                    )),
                                  ),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(5.0),
                                        primary: const Color.fromARGB(
                                            255, 143, 133, 226),
                                        textStyle:
                                            const TextStyle(fontSize: 20),
                                      ),
                                      child: const Text('Edit'),
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil<dynamic>(
                                          context,
                                          MaterialPageRoute<dynamic>(
                                            builder: (BuildContext context) =>
                                                EditPage(
                                              employee: Employee(
                                                  uid: e.id,
                                                  employeeName:
                                                      e["employee_name"],
                                                  position: e["position"],
                                                  contactNo: e["contact_no"]),
                                            ),
                                          ),
                                          (route) =>
                                              false, //if you want to disable back feature set to false
                                        );
                                      },
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(5.0),
                                        primary: const Color.fromARGB(
                                            255, 143, 133, 226),
                                        textStyle:
                                        const TextStyle(fontSize: 20),
                                      ),
                                      child: const Text('Image'),
                                      onPressed: () {
                                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>ImagesScreen()));
                                      },
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(5.0),
                                        primary: const Color.fromARGB(
                                            255, 143, 133, 226),
                                        textStyle:
                                            const TextStyle(fontSize: 20),
                                      ),
                                      child: const Text('Delete'),
                                      onPressed: () async {
                                        var response =
                                            await FirebaseCrud.deleteEmployee(
                                                docId: e.id);
                                        if (response.code != 200) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Text(response.message
                                                      .toString()),
                                                );
                                              });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  else if(title== searchFilter){
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListView(
                        children: snapshot.data!.docs.map((e) {
                          return Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("Name: " + e["employee_name"]),
                                  subtitle: Container(
                                    child: (Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Position: " + e['position'],
                                            style:
                                            const TextStyle(fontSize: 14)),
                                        Text(
                                            "Contact Number: " +
                                                e['contact_no'],
                                            style:
                                            const TextStyle(fontSize: 12)),
                                      ],
                                    )),
                                  ),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(5.0),
                                        primary: const Color.fromARGB(
                                            255, 143, 133, 226),
                                        textStyle:
                                        const TextStyle(fontSize: 20),
                                      ),
                                      child: const Text('Edit'),
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil<dynamic>(
                                          context,
                                          MaterialPageRoute<dynamic>(
                                            builder: (BuildContext context) =>
                                                EditPage(
                                                  employee: Employee(
                                                      uid: e.id,
                                                      employeeName:
                                                      e["employee_name"],
                                                      position: e["position"],
                                                      contactNo: e["contact_no"]),
                                                ),
                                          ),
                                              (route) =>
                                          false, //if you want to disable back feature set to false
                                        );
                                      },
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(5.0),
                                        primary: const Color.fromARGB(
                                            255, 143, 133, 226),
                                        textStyle:
                                        const TextStyle(fontSize: 20),
                                      ),
                                      child: const Text('Delete'),
                                      onPressed: () async {
                                        var response =
                                        await FirebaseCrud.deleteEmployee(
                                            docId: e.id);
                                        if (response.code != 200) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Text(response.message
                                                      .toString()),
                                                );
                                              });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                }

                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
