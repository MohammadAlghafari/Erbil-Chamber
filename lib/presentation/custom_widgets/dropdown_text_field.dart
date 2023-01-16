import 'package:flutter/material.dart';

class DropDownTextField extends StatelessWidget {
  const DropDownTextField(
      {Key key, @required this.hintText,@required this.errorText, @required this.handleTap,this.controller,this.node,})
      : super(key: key);
  final String hintText;
  final String errorText;
  final Function handleTap;
  final TextEditingController controller;
  final FocusNode node;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 7,),
        child: TextField(
          readOnly: true,
          controller: controller,
          focusNode: node,
          autofocus: false,
          style: TextStyle(
             fontWeight: FontWeight.w300,
              color: Colors.black,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 16, top:25 ,),
            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Icon(
                Icons.arrow_drop_down,
                size: 22,
                color: Theme.of(context).primaryColor,
              ),
            ),
              errorText: errorText,
          errorStyle: TextStyle(color: Colors.red),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          ),
          
          onTap: handleTap,
        ));
  }
}
