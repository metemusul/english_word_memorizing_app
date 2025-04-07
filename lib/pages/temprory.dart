import 'package:english_word_app/colors/generallyColors.dart';
import 'package:english_word_app/pages/mainPage.dart';
import 'package:flutter/material.dart';




class Temprory extends StatefulWidget {
  const Temprory({super.key});

  @override
  State<Temprory> createState() => _TemproryState();
}

class _TemproryState extends State<Temprory> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 2),() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Mainpage(),));
    },);
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Container(
          color: firsColors.primaryWhiteColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
             
             
             
              children: [
                Column(
                  children: [
                    Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Image.asset("assets/images/small_logo.png"),
                ),
                Text("QWorDaZy",style: TextStyle(color: firsColors.primaryBlackColor,fontFamily: "lucky",fontSize: 40),),

                  ],
                ),
                
                
                Text("İstediğini Öğren",style: TextStyle(color: firsColors.primaryBlackColor,fontFamily: "carter",fontSize: 25),),
                    
              ],
            ),
          ),
        ),
      ),

    );
  }
}