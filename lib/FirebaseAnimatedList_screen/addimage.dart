import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path_provider;


class AddImageScreen extends StatefulWidget {
  final String id;
  const AddImageScreen({Key? key,required this.id}) : super(key: key);

  @override
  State<AddImageScreen> createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {

  List<File> image = [];

  final picker = ImagePicker();

  late CollectionReference imgRef;

  late firebase_storage.Reference ref;
  bool uploading = false;
  double val =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Images"),
        actions: [
          ElevatedButton(onPressed: (){
            setState(() {
              uploading = true;
            });
            uploadFile().whenComplete(() {
              Fluttertoast.showToast(msg: "Images Uploaded SuccessFully");
              Navigator.pop(context);
            });
          }, child: const Text("Upload"),),
        ],
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.04,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)
              ),
            ),
          ),
          Expanded(child: Stack(
            children: [
              GridView.builder(
                  itemCount: image.length+1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), itemBuilder: (context , index){
                return index == 0 ? Center(
                  child: IconButton(
                    icon: const Icon(Icons.add), onPressed: () => !uploading ? chooseImage() : null
                  ),
                ): Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(image[index - 1]),
                        fit: BoxFit.cover
                    ),
                  ),
                );
              }),
              uploading ?  Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Loading.....",style: TextStyle(fontSize: 20,),),
                    CircularProgressIndicator(
                      value: val,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ],
                ),
              ):Container(),
            ],
          ),),
        ],
      ),
    );
  }

  chooseImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image.add(File(pickedFile!.path));
    });
  }

  Future uploadFile() async {
    int i = 0;
    for(var img in image){
      setState(() {
        val = i/image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance.ref('/images/${widget.id}/${path_provider.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async{
        await ref.getDownloadURL().then((value) {
          imgRef.add({'url':value});
          i++;
        });
      });
    }
  }

  @override
  void initState(){
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('imageURLs');
  }
}


