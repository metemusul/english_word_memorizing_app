import 'package:english_word_app/colors/generallyColors.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: firsColors.primaryWhiteColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
               alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width*0.2,
              child: InkWell(
                onTap: () {},
                child:Icon(Icons.arrow_back_ios,color: firsColors.primaryBlackColor,size:22 ,) 
                )
            ),
             Container(
             
              width: MediaQuery.of(context).size.width*0.5,
              margin:EdgeInsets.only(top: 10,left: 20),
             
              child: Text(capitalizeFirstLetter("listeler"),style: TextStyle(color: Colors.black,fontFamily: "lucky",fontSize: 25),),
            ),
             Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width*0.1,
              child: Image.asset("assets/images/small_logo.png"),

              
            )
          ],
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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