import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstday/screen/addimage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transparent_image/transparent_image.dart';


class ImagesGallery extends StatefulWidget {
  final String id;
  const ImagesGallery({Key? key,required this.id}) : super(key: key);

  @override
  State<ImagesGallery> createState() => _ImagesGalleryState();
}

class _ImagesGalleryState extends State<ImagesGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const
      Text("Gallery Images"),),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddImageScreen(id: widget.id)));
        },
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('imageURLs').snapshots(),
        builder: (context , snapshot){
          return !snapshot.hasData ? const Center(
            child: CircularProgressIndicator(),
          ): GridView.builder(
              itemCount: snapshot.data?.docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context , index){
            return InkWell(
              onTap: (){
                final ref = FirebaseFirestore.instance.collection('imageURLs').doc('url');
                print("Print Message");
                print(ref);
                // ref.delete();
                setState(() {

                });
                Fluttertoast.showToast(msg: "Message Deleted");
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageDetail(imageDetail: snapshot.data!.docs[index])));
              },
              child: Container(
                margin: const EdgeInsets.all(3),
                child: FadeInImage.memoryNetwork(
                    fit: BoxFit.cover,
                    placeholder: kTransparentImage,
                    image: snapshot.data?.docs[index].get('url'),),
              ),
            );
              });
        },
      ),
    );
  }
}
