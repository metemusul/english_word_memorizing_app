import 'package:english_word_app/colors/generallyColors.dart';

import 'package:english_word_app/global_widget/app_bar.dart';
import 'package:english_word_app/db/db/db.dart';
import 'package:english_word_app/db/models/lists.dart';
import 'package:english_word_app/db/models/words.dart';
import 'package:english_word_app/global_widget/toast.dart';
import 'package:english_word_app/pages/lists_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CreateList extends StatefulWidget {
  const CreateList({super.key});

  @override
  State<CreateList> createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {
  final _listname = TextEditingController();
  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 10; i++) {
      wordTextEditingList.add(TextEditingController());
    }

    for (var i = 0; i < 5; i++) {
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
    return Scaffold(
      appBar: appBar(
        context,
        left: Icon(Icons.arrow_back_ios, color: firsColors.primaryBlackColor, size: 22),
        right: Image.asset("assets/images/logo.png"),
        center: Text("QWORDAZY", style: TextStyle(color: Colors.black, fontFamily: "lucky", fontSize: 25)),
        leftWidgetonClick: () => Navigator.pop(context)
      ),
      body: Container(
        color: firsColors.primaryWhiteColor,
        child: Column(
          children: [
            textFieldBuilder(
              icon: Icon(Icons.list),
              hintText: "Liste Adı",
              controller: _listname,
              textAlign: TextAlign.left,
            ),
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

    if (!_listname.text.isEmpty) {
      
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

    if (counter >= 4) {
      if (!notEmptyPair) 
      {
        Lists addedList = await DB.instance.insertList(Lists(name: _listname.text));
          for (var i = 0; i < wordTextEditingList.length/2; i++) {
         String eng = wordTextEditingList[2*i].text;
         String tr = wordTextEditingList[2*i+1].text;
         Word word = await DB.instance.insertWord(Word(list_id: addedList.id,word_eng: eng,word_tr: tr,status: false));
        debugPrint(word.id.toString()+ " " + word.list_id.toString() +" "+ word.word_eng.toString() + " " + word.word_tr.toString() + " " + word.status.toString());

    }

      toastMessage("Liste oluşturuldu.");
    _listname.clear();
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
      toastMessage("Minimum 4 Çift dolu olmalıdır . !!!");

    
    }
    }

    else{
      toastMessage("Lütfen liste adını girin.");

    }

    
  }

  void remoweRow() {
    if (wordListField.length > 4) {
      wordTextEditingList.removeAt(wordTextEditingList.length-1);
      wordTextEditingList.removeAt(wordTextEditingList.length-1);
      wordListField.removeAt(wordListField.length-1);
      setState(() {});
    } else {
           toastMessage("Minimum 4 gereklidir . !!!");

    }
  }

  InkWell actionButton(Function() click, IconData icon) {
    return InkWell(
      onTap: click,
      child: Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.only(left: 25, bottom: 40),
        child: Icon(icon, size: 32),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 220, 129, 38),
          shape: BoxShape.circle
        ),
      ),
    );
  }

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
}

