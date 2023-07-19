import 'package:flutter/material.dart';

class ImageDetail extends StatefulWidget {
  final imageDetail;
  const ImageDetail({Key? key,required this.imageDetail}) : super(key: key);

  @override
  State<ImageDetail> createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.imageDetail),
      ),
    );
  }
}
