import 'package:flutter/material.dart';
import 'package:final_project/model/category.dart';

class Keyword extends StatefulWidget{
  @override
  State<Keyword> createState() => _KeywordState();
}

class _KeywordState extends State<Keyword> {
  final TextEditingController _textController = TextEditingController();
  var ischecked = false;
  @override
  Widget build(context){
    return Container(
      height: 200,
      child:Center(
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration:
                        const InputDecoration(hintText: 'Enter keyword or message'),
                    maxLines: null,
                  ),
                ),
              ],
            ),           
            SizedBox(width:100.0),          
            Checkbox(
              value: ischecked,
              onChanged: (bool?value){
                setState(() {
                  ischecked = value!;
                });

              }),
              Text("Picture",style:TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold))
          ],
        ), 
      ) 
    );
  }
}