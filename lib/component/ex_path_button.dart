import 'package:flutter/material.dart';

class ExPathButton extends StatefulWidget{
   ExPathButton({super.key, required this.title, this.onPressed,this.hasPress});

  final String title;

  final VoidCallback? onPressed;

  bool?  hasPress;

  @override
  State<StatefulWidget> createState() =>_ExPathButtonState();

}
class _ExPathButtonState extends State<ExPathButton>{
  @override
  Widget build(BuildContext context) {
    if(widget.hasPress !=null && widget.hasPress!){
      return InkWell(
          onTap:widget.onPressed,
        child:  Text(widget.title,style:const TextStyle(color: Colors.lightBlueAccent)),
      );
    }
    return  Text(widget.title);
  }

}