import 'package:english_word_app/colors/generallyColors.dart';
import 'package:english_word_app/db/db/db.dart';
import 'package:english_word_app/db/models/words.dart';
import 'package:english_word_app/global_widget/app_bar.dart';
import 'package:english_word_app/global_widget/textFieldBuilder.dart';
import 'package:english_word_app/global_widget/toast.dart';
import 'package:english_word_app/pages/lists_page.dart';
import 'package:flutter/material.dart';

class addWordPAge extends StatefulWidget {

   final int ?ListID;
  final  String ?ListName;
  const addWordPAge(this.ListID,this.ListName, {Key? key}) : super(key:key);

     @override
     State<addWordPAge> createState() => _addWordPAgeState(ListID: ListID,ListName: ListName);
}

class _addWordPAgeState extends State<addWordPAge> {
   int ?ListID;
   String ?ListName;

  _addWordPAgeState({@required this.ListID,@required this.ListName}){}


  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];



    @override
  void initState() {
    super.initState();

    for (var i = 0; i < 6; i++) {
      wordTextEditingList.add(TextEditingController());
    }

    for (var i = 0; i < 3; i++) {
      wordListField.add(
        Row(
          children: [
            Expanded(child: textFieldBuilder(controller: wordTextEditingList[2*i])),
            Expanded(child: textFieldBuilder(controller: wordTextEditingList[2*i+1])),
          ],
        )
      );
    }
  }





  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: appBar(context,
       left: Icon(Icons.arrow_back_ios,color: firsColors.primaryBlackColor,size:22 ,) ,
        center: Text(capitalizeFirstLetter(ListName!),style: TextStyle(color: Colors.black,fontFamily: "lucky",fontSize: 25),),
        right:  Icon(Icons.add,color: Colors.black, size: 22,),
        leftWidgetonClick:()=>{Navigator.pop(context)}
         ),
      body: SafeArea(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("İngilizce", style: TextStyle(fontSize: 18, fontFamily: "robotoregular")),
                    Text("Türkçe", style: TextStyle(fontSize: 18, fontFamily: "robotoregular")),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: wordListField,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  actionButton(addRow, Icons.add),
                  actionButton(saveRow, Icons.save),
                  actionButton(remoweRow, Icons.remove),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }



   void addRow() {
    wordTextEditingList.add(TextEditingController());
    wordTextEditingList.add(TextEditingController());

    wordListField.add(
      Row(
        children: [
          Expanded(child: textFieldBuilder(controller: wordTextEditingList[wordTextEditingList.length-2])),
          Expanded(child: textFieldBuilder(controller: wordTextEditingList[wordTextEditingList.length-1])),
        ],
      )
    );

    setState(() {});
  }

  void saveRow() async {

     
      
    int counter = 0;
    bool notEmptyPair = false;

    for (var i = 0; i < wordTextEditingList.length/2; i++) {
      String eng = wordTextEditingList[2*i].text;
      String tr = wordTextEditingList[2*i+1].text;

      if (!eng.isEmpty && !tr.isEmpty) {
        counter++;
       
      }
      else{
        notEmptyPair = true;
      }
    }

    if (counter >= 1) {
      if (!notEmptyPair) 
      {
          for (var i = 0; i < wordTextEditingList.length/2; i++) {
         String eng = wordTextEditingList[2*i].text;
         String tr = wordTextEditingList[2*i+1].text;
         Word word = await DB.instance.insertWord(Word(list_id: ListID,word_eng: eng,word_tr: tr,status: false));
        debugPrint(word.id.toString()+ " " + word.list_id.toString() +" "+ word.word_eng.toString() + " " + word.word_tr.toString() + " " + word.status.toString());

    }

      toastMessage("Kelimeler eklendi . ");
  
    wordTextEditingList.forEach((element){
      element.clear();
    });

      }
      
      else
       {
       toastMessage("Boş alanları doldurun veya silin");
      }
    } 
    else 
    {
      toastMessage("Minimum 1 Çift dolu olmalıdır . !!!");

    
    }
    

   
    
  }

  void remoweRow() {
    if (wordListField.length > 1) {
      wordTextEditingList.removeAt(wordTextEditingList.length-1);
      wordTextEditingList.removeAt(wordTextEditingList.length-1);
      wordListField.removeAt(wordListField.length-1);
      setState(() {});
    } else {
           toastMessage("Minimum 1 gereklidir . !!!");

    }
  }



 InkWell actionButton(Function() click, IconData icon) {
    return InkWell(
      onTap: click,
      child: AnimatedScale(
        scale: 1.0,
        duration: Duration(milliseconds: 200),
        child: Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.only(left: 25, bottom: 40),
          child: Icon(icon, size: 32),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle
          ),
        ),
      ),
    );
  }







}