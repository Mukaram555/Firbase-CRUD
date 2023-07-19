// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
//
// import 'crud.dart';
//
// class ImagesScreen extends StatefulWidget {
//   const ImagesScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ImagesScreen> createState() => _ImagesScreenState();
// }
//
// class _ImagesScreenState extends State<ImagesScreen> {
//   // final Stream<QuerySnapshot> imageReference = FirebaseCrud.getImages();
//   final storageRef = FirebaseStorage.instance.ref();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Welcome"),
//       ),
//       body: Expanded(
//         child: StreamBuilder(
//           stream: imageReference,
//           builder: (context, snapshot) {
//             final CollectionReference title = fireStore.collection('imageURLs');
//             if (snapshot.hasData) {
//                 return Padding(
//                   padding:const  EdgeInsets.only(top: 8.0),
//                   child: ListView(
//                     children: snapshot.data!.docs.map((e) {
//                       return Card(
//                         child: Column(
//                           children: [
//                             Container(
//                               width: double.infinity,
//                               height: 100,
//                               child:Image.network(e['url']),
//                             ),
//                             ButtonBar(
//                               alignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 // TextButton(
//                                 //   style: TextButton.styleFrom(
//                                 //     padding: const EdgeInsets.all(5.0),
//                                 //     primary: const Color.fromARGB(
//                                 //         255, 143, 133, 226),
//                                 //     textStyle:
//                                 //     const TextStyle(fontSize: 20),
//                                 //   ),
//                                 //   child: const Text('Edit'),
//                                 //   onPressed: () {
//                                 //     Navigator.pushAndRemoveUntil<dynamic>(
//                                 //       context,
//                                 //       MaterialPageRoute<dynamic>(
//                                 //         builder: (BuildContext context) =>
//                                 //             EditPage(
//                                 //               employee: Employee(
//                                 //                   uid: e.id,
//                                 //                   employeeName:
//                                 //                   e["employee_name"],
//                                 //                   position: e["position"],
//                                 //                   contactNo: e["contact_no"]),
//                                 //             ),
//                                 //       ),
//                                 //           (route) =>
//                                 //       false, //if you want to disable back feature set to false
//                                 //     );
//                                 //   },
//                                 // ),
//                                 TextButton(
//                                   style: TextButton.styleFrom(
//                                     padding: const EdgeInsets.all(5.0),
//                                     primary: const Color.fromARGB(
//                                         255, 143, 133, 226),
//                                     textStyle:
//                                     const TextStyle(fontSize: 20),
//                                   ),
//                                   child: const Text('Image'),
//                                   onPressed: () {
//
//                                   },
//                                 ),
//                                 TextButton(
//                                   style: TextButton.styleFrom(
//                                     padding: const EdgeInsets.all(5.0),
//                                     primary: const Color.fromARGB(
//                                         255, 143, 133, 226),
//                                     textStyle:
//                                     const TextStyle(fontSize: 20),
//                                   ),
//                                   child: const Text('Delete'),
//                                   onPressed: () async {
//                                     var response =
//                                     await FirebaseCrud.deleteEmployee(
//                                         docId: e.id);
//                                     if (response.code != 200) {
//                                       showDialog(
//                                           context: context,
//                                           builder: (context) {
//                                             return AlertDialog(
//                                               content: Text(response.message
//                                                   .toString()),
//                                             );
//                                           });
//                                     }
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 );
//
//             }
//
//             return Container();
//           },
//         ),
//       ),
//     );
//   }
// }
