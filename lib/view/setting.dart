import 'package:flutter/material.dart';
import 'package:final_project/model/category.dart';

class Setting extends StatefulWidget{
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  var ischecked = false;
  var _selectedCategory = role.family;
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
                Text('Who are you chatting now'),
                DropdownButton(
                  value: _selectedCategory,
                  items: role.values
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(
                        category.name.toUpperCase(),
                      ),
                    ),
                  ).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
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