import 'package:english_word_app/colors/generallyColors.dart';
import 'package:english_word_app/db/db/db.dart';
import 'package:english_word_app/db/models/words.dart';
import 'package:english_word_app/global_widget/app_bar.dart';
import 'package:english_word_app/global_widget/toast.dart';
import 'package:english_word_app/pages/add_word.dart';
import 'package:english_word_app/pages/lists_page.dart';
import 'package:flutter/material.dart';


class WordsPage extends StatefulWidget {
  final int ?ListID;
  final String ?ListName;

  const WordsPage({super.key, this.ListID, this.ListName});

  @override
  State<WordsPage> createState() => _WordsPageState(ListID:ListID,ListName:ListName  );
}

class _WordsPageState extends State<WordsPage> {

   int ?ListID;
   String ?ListName;

   _WordsPageState({@required this.ListID,@required this.ListName}){}

   List<Word> _wordList = [];

   bool pressController = false;
   List<bool> deleteIndexList = [];


   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint(ListID.toString() + "  " + ListName!);
    getWordByList();
  }

  void getWordByList() async {
    _wordList = await DB.instance.readWordByList(ListID);
    for (int i = 0; i < _wordList.length; i++) {
      deleteIndexList.add(false);
    }

    setState(() => _wordList);
  }

  void delete() async{
    List<int> remoweIndexList = [];
    for (int i = 0; i < deleteIndexList.length; i++) {
      if (deleteIndexList[i] == true) {
        remoweIndexList.add(i);

      }
    }

    for (int i = remoweIndexList.length-1; i >= 0; i--) {
      DB.instance.deleteWord(_wordList[remoweIndexList[i]].id!);
      _wordList.removeAt(remoweIndexList[i]);
      deleteIndexList.removeAt(remoweIndexList[i]);
    }

  setState(() {
    _wordList;
    deleteIndexList;
    pressController = false;

  });

  toastMessage("Seçili kelimeler silindi");



  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: appBar(context,
       left: Icon(Icons.arrow_back_ios,color: firsColors.primaryBlackColor,size:22 ,) ,
        center: Text(capitalizeFirstLetter(ListName!),style: TextStyle(color: Colors.black,fontFamily: "lucky",fontSize: 25),),
        right: pressController!= true?  Image.asset("assets/images/logo.png") :InkWell(
          onTap: delete,
          child:  Icon(Icons.delete,color: const Color.fromARGB(255, 233, 132, 16),size: 24,),),
        leftWidgetonClick:()=>{Navigator.pop(context)}
         ),
      body: SafeArea(
        child:   ListView.builder(itemBuilder: (context,index){
          return wordItem(_wordList[index].id!, index, word_tr: _wordList[index].word_tr, word_eng: _wordList[index].word_eng, status: _wordList[index].status) ;
        },itemCount:_wordList.length ,)
        ),

         floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => addWordPAge(ListID,ListName))).then((value) {
            getWordByList();
          });
        },
        child: Icon(Icons.add,color: firsColors.primaryWhiteColor,),
        backgroundColor: const Color.fromARGB(255, 233, 132, 16),
        
        
        )
    );
  }

  InkWell wordItem(int word_id , int index ,{@required String ?word_tr , @required String ?word_eng, @required bool ?status }) {
    return InkWell(
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
                        margin: EdgeInsets.only(left: 10,top: 10),
                        child: Text(word_tr! ,style: TextStyle(color:firsColors.primaryBlackColor,fontSize: 18,fontFamily: "robotomedium"),)),
                      Container(
                        margin: EdgeInsets.only(left: 20,bottom: 10),
                        child: Text(word_eng!,style: TextStyle(color:firsColors.primaryBlackColor,fontSize: 16,fontFamily: "robotoregular"),)),
                      
                    ],
                  ),
      
                   pressController!= true? Checkbox(
                     checkColor: Colors.white,
                      activeColor: Colors.black,
                      hoverColor:Colors.blueAccent,
                      value: status,
                      onChanged: (bool? value) 
                      {
                          _wordList[index] = _wordList[index].copy(status: value);
                          if (value== true) {
                            toastMessage("öğrenildi olarak işaretlendi ");
                            DB.instance.markAsLearned(true, _wordList[index].id as int);
                          }
                          else{
                            toastMessage("öğrenilmedi olarak işaretlendi ");
                            DB.instance.markAsLearned(false, _wordList[index].id as int);
                          }
      
                          setState(() {
                            _wordList;
                            
                          });
                      },
                  ) : Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.black,
                      hoverColor:Colors.blueAccent,
                      value: deleteIndexList[index],
                      onChanged: (bool ?value){
                        setState(() {
                           deleteIndexList[index] = value!;
                          bool deleteProcessController = false;
                          deleteIndexList.forEach((element){
                            if (element == true) {
                                deleteProcessController = true;
                            }
                          });

                          if (!deleteProcessController) {
                            pressController = false;
                          }

                        });
                         

                      },
                    )
                
        
                    ],
                  ),
                ),
                ),
      ),
    );
  }
}