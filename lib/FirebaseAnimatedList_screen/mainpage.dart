import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firstday/screen/updateprofileImage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'addpost.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'imagesScreen.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("Employee");
  firebase_storage.Reference refer =
  firebase_storage.FirebaseStorage.instance.ref('/images');
  final searchFilter = TextEditingController();
  final nameController = TextEditingController();
  final positionController = TextEditingController();
  final contactController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Of Employee"),
        centerTitle: true,
        actions: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.02,
          ),
          IconButton(onPressed: (){}, icon: const Icon(Icons.logout))
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.01,
            ),
            TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                hintText: 'Search..',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value){
                setState(() {

                });
              },
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.01,
            ),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: const Center(
                  child: CircularProgressIndicator(),
                ),
                  query: ref,
                  itemBuilder: (context,snapshot,animation,index ){
                  final title = snapshot.child('name').value.toString();
                  final pos = snapshot.child('Position').value.toString();
                  final cont = snapshot.child('contact').value.toString();

                if(searchFilter.text.isEmpty){
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("ID: ${snapshot.child('id').value.toString()}",),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateProfileImage(id: snapshot.child('id').value.toString(),),),);
                                },
                                child: Container(width: 100,height: 100,
                                  child: CircleAvatar(
                                  radius: 40,
                                    backgroundImage: NetworkImage(snapshot.child('imgUrl').value.toString()),
                                  ),
                                ),
                              ),

                            ],
                          ),
                          subtitle: Container(
                            child: (Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text("Name: ${snapshot.child('name').value}",
                                    style:
                                    const TextStyle(fontSize: 14)),
                                Text(
                                    "Position: ${snapshot.child('Position').value}",
                                    style:
                                    const TextStyle(fontSize: 12)),
                                Text(
                                    "Contact Number: ${snapshot.child('contact').value}",
                                    style:
                                    const TextStyle(fontSize: 12)),
                              ],
                            )),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(onPressed: (){
                              showMyDialog(title,pos,cont,snapshot.child('id').value.toString());

                            }, icon: const Icon(Icons.edit),),
                            IconButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ImagesGallery(id: snapshot.child('id').value.toString(),)));

                            }, icon: const Icon(Icons.image),),
                            IconButton(onPressed: (){
                              refer.child(snapshot.child('id').value.toString()).delete();
                              ref.child(snapshot.child('id').value.toString()).remove().then((value) {
                                Fluttertoast.showToast(msg: "Record Deleted SuccessFully");
                              }).onError((error, stackTrace) {
                                Fluttertoast.showToast(msg: error.toString());
                              });
                            }, icon: const Icon(Icons.delete,color: Colors.red,),),
                          ],
                        )
                      ],
                    ),
                  );
                }else if(title.toString().toLowerCase().contains(searchFilter.text.toString().toLowerCase())){
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ID: ${snapshot.child('id').value.toString()}",),
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.red,
                          // child: Image.network(e['url']),
                        )
                      ],
                    ),
                    subtitle: Container(
                      child: (Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text("Name: ${snapshot.child('name').value}",
                              style:
                              const TextStyle(fontSize: 14)),
                          Text(
                              "Position: ${snapshot.child('Position').value}",
                              style:
                              const TextStyle(fontSize: 12)),
                          Text(
                              "Contact Number: ${snapshot.child('contact').value}",
                              style:
                              const TextStyle(fontSize: 12)),
                          Divider(
                            height: MediaQuery.sizeOf(context).height * 0.02,
                            thickness: 2,
                          ),
                        ],
                      )),
                    ),
                  );
                }else{
                  return Container();
                }
                  }),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddPostScreen()));
              },
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.06,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(child: Text("Add Post",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
              ),
            )
          ],
        ),
      ),
    );
  }
  
  Future<void> showMyDialog(String name,String position, String contactNumber, String id) async{
    nameController.text = name;
    positionController.text = position;
    contactController.text = contactNumber;
    return showDialog(context: context, builder: ( BuildContext context){
      return AlertDialog(
        title: const Center(child: Text("Update"),),
        content: SizedBox(
          height: MediaQuery.sizeOf(context).height/1.5,
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Name",
                ),
              ),
              TextField(
                controller: positionController,
                decoration: const InputDecoration(
                  hintText: "Position",
                ),
              ),
              TextField(
                keyboardType: TextInputType.phone,
                controller: contactController,
                decoration: const InputDecoration(
                  hintText: "Contact Number",
                ),
              ),
            ],
          ),
        ),
        actions: [

          TextButton(onPressed: (){
            ref.child(id).update({
              'Position': positionController.text.toString(),
              'contact': contactController.text.toString(),
              'name':nameController.text.toString(),
            }).then((value) {
              Fluttertoast.showToast(msg: "Data Updated Successfully");
              Navigator.pop(context);
            }).onError((error, stackTrace) {
              Fluttertoast.showToast(msg: error.toString());
            });
          }, child: const Text("Update")),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("Cancel")),
        ],
      );
    });
  }
}
