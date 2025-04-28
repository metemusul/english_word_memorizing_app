import 'package:english_word_app/colors/generallyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


PreferredSize appBar(context, {@required Widget ?left,@required Widget ?center,Widget ?right,Function() ?leftWidgetonClick}){

  return PreferredSize(preferredSize: Size.fromHeight(50), child: AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: firsColors.primaryWhiteColor,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width *0.20,
          child: InkWell(
            onTap: () =>leftWidgetonClick!(),
            child: left,
          ),
        ),
         Container(
          margin: EdgeInsets.only(right: 20),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width *0.40,
          child: center,
        ),
         Container(
          alignment: Alignment.centerRight,
          width: MediaQuery.of(context).size.width *0.15,
          child: right,
        ),
      ],
    ),
  ));
}