import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
// if you don't add universal_html to your dependencies you should
// write import 'dart:html' as html; instead
import 'package:universal_html/html.dart' as html;


class BigPicture extends StatefulWidget{
  BigPicture(this.picture_src);
  final String picture_src;
  @override
  State<BigPicture> createState() => _BigPictureState();
}
class _BigPictureState extends State<BigPicture> {
  bool downloading = false;
   Future<void> downloadImage(String url) async {
    await WebImageDownloader.downloadImageFromWeb(url); 
  }
  @override
  Widget build(context){
    return
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          Container(
            height: 350,
            child: Image.network(
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {           
              return  const Center(
                child: Text(
                '圖片已過期',
                style: TextStyle(fontFamily:'abc',color: Colors.red),
                ),
              );
            },
            widget.picture_src,
            ),
          ),
          SizedBox(height: 5,),
          IconButton.filled(
            onPressed: (){
              downloadImage(widget.picture_src);
            }, 
            icon: Icon(Icons.download)
          ),
        ],
      );
  }
}