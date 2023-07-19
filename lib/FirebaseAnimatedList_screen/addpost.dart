import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firstday/screen/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? image;
  bool loading = false;
  final picker = ImagePicker();
  final id = DateTime.now().millisecondsSinceEpoch.toString();

  Future getGalleryImage() async {
    final pickFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickFile != null) {
        image = File(pickFile.path);
      } else {
        Fluttertoast.showToast(msg: "No Image Selected");
      }
    });
  }

  Future getCameraImage() async {
    final pickFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    setState(() {
      if (pickFile != null) {
        image = File(pickFile.path);
      } else {
        Fluttertoast.showToast(msg: "No Image Selected");
      }
    });
  }

  Future uploadData() async {
    // To upload Image
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('/images/$id');
    firebase_storage.UploadTask uploadTask = ref.putFile(image!.absolute);

    Future.value(uploadTask).then((value) async {
      var newUrl = await ref.getDownloadURL();
      databaseRef.child(id).set({
        'id': id.toString(),
        'name': nameController.text.toString(),
        'Position': positionController.text.toString(),
        'contact': contactNumber.text.toString(),
        'imgUrl': newUrl.toString(),
      }).then((value) {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(msg: "File Uploaded");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }).onError((error, stackTrace) {
        Fluttertoast.showToast(msg: error.toString());
      });
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: error.toString());
    });
  }

  final databaseRef = FirebaseDatabase.instance.ref("Employee");
  final nameController = TextEditingController();
  final positionController = TextEditingController();
  final contactNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  getGalleryImage();
                },
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2.5,
                  height: MediaQuery.sizeOf(context).height * 0.2,
                  child: image != null
                      ? Image.file(
                          image!.absolute,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.image,
                          size: MediaQuery.sizeOf(context).height * 0.2,
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Ali",
                  label: const Text('Name'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: positionController,
                decoration: InputDecoration(
                  hintText: "Position",
                  label: const Text('Position'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: contactNumber,
                decoration: InputDecoration(
                  hintText: "0300 0000000",
                  label: const Text('Contact'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  uploadData();

                  // final id = DateTime.now().millisecondsSinceEpoch.toString();
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                  ),
                  child: Center(
                      child: loading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                              "Upload Data",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
