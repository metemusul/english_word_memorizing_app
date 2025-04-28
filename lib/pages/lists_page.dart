import 'package:english_word_app/colors/generallyColors.dart';
import 'package:english_word_app/global_widget/app_bar.dart';
import 'package:english_word_app/pages/create_list.dart';
import 'package:flutter/material.dart';


class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: firsColors.primaryWhiteColor,
      appBar:appBar(context,
       left: Icon(Icons.arrow_back_ios,color: firsColors.primaryBlackColor,size:22 ,) ,
        center: Text(capitalizeFirstLetter("listeler"),style: TextStyle(color: Colors.black,fontFamily: "lucky",fontSize: 25),),
        right: Image.asset("assets/images/logo.png"),
        leftWidgetonClick:()=>{Navigator.pop(context)}
         ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateList()));
        },
        child: Icon(Icons.add,color: firsColors.primaryWhiteColor,),
        backgroundColor: const Color.fromARGB(255, 233, 132, 16),
        
        
        ),

      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                child: Card(
                  color: const Color.fromARGB(255, 241, 201, 141),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  margin: EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10,top: 5),
                        child: Text("Liste Adı",style: TextStyle(color:firsColors.primaryBlackColor,fontSize: 16,fontFamily: "robotomedium"),)),
                      Container(
                        margin: EdgeInsets.only(left: 20,top: 2),
                        child: Text("Liste Adı",style: TextStyle(color:firsColors.primaryBlackColor,fontSize: 14,fontFamily: "robotoregular"),)),
                      Container(
                         margin: EdgeInsets.only(left: 20,top: 2),
                        child: Text("Liste Adı",style: TextStyle(color:firsColors.primaryBlackColor,fontSize: 14,fontFamily: "robotoregular"),)),
                      Container(
                         margin: EdgeInsets.only(left: 20,top: 2),
                        child: Text("Liste Adı",style: TextStyle(color:firsColors.primaryBlackColor,fontSize: 14,fontFamily: "robotoregular"),)),
                    ],
                  ),
                ),
                ),
            ),




          



          ],
        ),
        
        )

    );
  }
}


String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}