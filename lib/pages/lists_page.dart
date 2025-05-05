import 'package:english_word_app/colors/generallyColors.dart';
import 'package:english_word_app/global_widget/app_bar.dart';
import 'package:english_word_app/global_widget/toast.dart';
import 'package:english_word_app/pages/create_list.dart';
import 'package:english_word_app/pages/words.dart';
import 'package:flutter/material.dart';
import 'package:english_word_app/db/db/db.dart';


class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {


  List<Map<String,Object?>> _lists = [];

  bool pressController = false;
  List<bool> deleteIndexList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
 
  }

 void getList() async {
   _lists = await DB.instance.readListsAll();
   for (int i = 0; i < _lists.length; i++) {
    deleteIndexList.add(false);
     
   }
   setState(() {
     _lists;
   });
 }

 void delete() async{
    List<int> remoweIndexList = [];
    for (int i = 0; i < _lists.length; i++) {
      if (deleteIndexList[i] == true) {
        remoweIndexList.add(i);
      }   
    }


  for (int i = remoweIndexList.length-1; i >= 0; i--) {
    DB.instance.deleteListsAndWordByList(_lists[remoweIndexList[i]]['list_id'] as int);
    _lists.removeAt(remoweIndexList[i]);
    deleteIndexList.removeAt(remoweIndexList[i]);
  }
  for (int i = 0; i < deleteIndexList.length; i++) {
    deleteIndexList[i] = false;
    
  }

  setState(() {
    _lists;
    deleteIndexList;
    pressController= false;
  });


  toastMessage("Seçili listeler silindi ");


 }

  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: firsColors.primaryWhiteColor,
      appBar:appBar(context,
       left: Icon(Icons.arrow_back_ios,color: firsColors.primaryBlackColor,size:22 ,) ,
        center: Text(capitalizeFirstLetter("listeler"),style: TextStyle(color: Colors.black,fontFamily: "lucky",fontSize: 25),),
        right: pressController!= true ?   Image.asset("assets/images/logo.png"): InkWell(
          onTap:delete,
          child: Icon(Icons.delete,color: const Color.fromARGB(255, 233, 132, 16),size: 24,),
        ),
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
        child: ListView.builder(
          itemBuilder: (context,index){
          return listItem(_lists[index]['list_id'] as int,index, listName: _lists[index]['name'].toString(), sumWords: _lists[index]['sum_word'].toString(), sumUnlearned: _lists[index]['sum_unlearned'].toString());
          },
          itemCount:_lists.length ,


         ),
        
        )

    );
  }

  InkWell listItem(int id,int index, {@required String ?listName,@required String ?sumWords,@required String ?sumUnlearned, }) {
    return InkWell(
      onTap: (){
        debugPrint(id.toString());
        Navigator.push(context, MaterialPageRoute(builder: (context)=>WordsPage(ListID: id, ListName:listName ))).then((value) {
         getList();

        });
      
      },
      onLongPress: () {
       setState(() {
          pressController = true;
          deleteIndexList[index] = true;
       });
      },
      
      child: Center(
        child: Container(
                width: double.infinity,
                child: Card(
                  color: const Color.fromARGB(255, 241, 201, 141),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  margin: EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 5),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10,top: 5),
                        child: Text(listName!,style: TextStyle(color:firsColors.primaryBlackColor,fontSize: 16,fontFamily: "robotomedium"),)),
                      Container(
                        margin: EdgeInsets.only(left: 20,top: 2),
                        child: Text(sumWords! + " terim ",style: TextStyle(color:firsColors.primaryBlackColor,fontSize: 14,fontFamily: "robotoregular"),)),
                      Container(
                         margin: EdgeInsets.only(left: 20,top: 2),
                        child: Text((int.parse(sumWords!) - int.parse(sumUnlearned!)).toString()  + " öğrenildi",style: TextStyle(color:firsColors.primaryBlackColor,fontSize: 14,fontFamily: "robotoregular"),)),
                      Container(
                         margin: EdgeInsets.only(left: 20,top: 2),
                        child: Text(sumUnlearned! + " öğrenilmedi",style: TextStyle(color:firsColors.primaryBlackColor,fontSize: 14,fontFamily: "robotoregular"),)),
                    ],
                  ),
                  pressController==true? Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.black,
                    hoverColor:Colors.blueAccent,
                    value: deleteIndexList[index],
                    onChanged: (bool? value){
                      setState(() {
                        deleteIndexList[index] = value!;
                        bool deleteProcessController = false;
        
                        deleteIndexList.forEach((element){
                            if (element==true) {
                              deleteProcessController = true;
                            }
                        });
        
                        if (!deleteProcessController) {
                          pressController = false;
                        }
                      });
                    },
        
                  ): Container()
        
                    ],
                  ),
                ),
                ),
      ),
          );
  }
}


String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}