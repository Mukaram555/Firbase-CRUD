import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UpdateProfileImage extends StatefulWidget {
  final id;
  const UpdateProfileImage({Key? key, required this.id}) : super(key: key);

  @override
  State<UpdateProfileImage> createState() => _UpdateProfileImageState();
}


class _UpdateProfileImageState extends State<UpdateProfileImage> {

  final picker = ImagePicker();
  File? image;
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref("Employee");


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

  void updateImage() async{
    final id1 = widget.id;
    firebase_storage.Reference ref =
    firebase_storage.FirebaseStorage.instance.ref('/images/$id1');
    firebase_storage.UploadTask uploadTask = ref.putFile(image!.absolute);
    Future.value(uploadTask).then((value) async {
      var newUrl = await ref.getDownloadURL();
      databaseRef.child(id1).update({
        'imgUrl':newUrl.toString(),
      });
    }).then((value) {
      Fluttertoast.showToast(msg: "Image Updated Successfully");
      Navigator.pop(context);
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: error.toString());
    });
        }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                getGalleryImage();
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.4,
                height: MediaQuery.sizeOf(context).height * 0.2,
                child: image != null ? Image.file(
                  image!.absolute,
                  fit: BoxFit.cover,
                )
                    : Icon(
                  Icons.image,
                  size: MediaQuery.sizeOf(context).height * 0.2,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.2,
            ),
            InkWell(
              onTap: (){
                setState(() {
                  loading = true;
                });
                updateImage();
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.9,
                height: MediaQuery.sizeOf(context).height * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: Center(
                  child:loading ? Center(child: CircularProgressIndicator()): Text("Update Image",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
// }

}
