import 'package:flutter/material.dart';



 Container textFieldBuilder({
    int height = 40,
    required TextEditingController controller,
    Icon? icon,
    String? hintText,
    TextAlign textAlign = TextAlign.center
  }) {
    return Container(
      height: double.parse(height.toString()),
      padding: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
      child: TextField(
        keyboardType: TextInputType.name,
        maxLines: 1,
        textAlign: textAlign,
        controller: controller,
        style: TextStyle(
          color: Colors.black,
          fontFamily: "robotomedium",
          decoration: TextDecoration.none,
          fontSize: 18
        ),
        decoration: InputDecoration(
          icon: icon,
          border: InputBorder.none,
          hintText: hintText,
          fillColor: Colors.transparent
        ),
      ),
    );
  }
