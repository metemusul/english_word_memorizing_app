import 'dart:math';

import 'package:english_word_app/db/db/db.dart';
import 'package:english_word_app/db/models/words.dart';
import 'package:english_word_app/global_variable.dart';
import 'package:english_word_app/global_widget/app_bar.dart';
import 'package:english_word_app/global_widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MultipleChoice extends StatefulWidget {
  const MultipleChoice({super.key});

  @override
  State<MultipleChoice> createState() => _MultipleChoice();
}

enum Which {learn,unlearned,all}

enum forWhat {forList,ForListMixed}

class _MultipleChoice extends State<MultipleChoice> {


Which? _chooseQuestionType = Which.learn;
bool listMixed = true;
List<Map<String,Object?>> _lists = [];
List<bool> selectedListIndex = [];


@override
  void initState() {
    super.initState();
    getList();
  }


  void getList() async{
    _lists = await DB.instance.readListsAll();
    for (int i = 0; i < _lists.length; i++) {
      selectedListIndex.add(false);
    }
    setState(() {
      _lists;
    });
  }


  List<Word> _words = [];

  bool start = false;

  List<List<String>> optionsList = [];
  List<String> correctAnswers = [];
  List<bool> clickControl = [];
  List<List<bool>> clickControlList = [];
  int correctCount = 0;
  int wrongCount = 0;
 

  void getSelectedWordOfLists(List<int> selectedListId) async {
    // Önce mevcut listeleri temizleyelim
    _words = [];
    optionsList = [];
    correctAnswers = [];
    clickControl = [];
    clickControlList = [];
    correctCount = 0;
    wrongCount = 0;

    if (_chooseQuestionType == Which.learn) {
        _words = await DB.instance.readWordByLists(selectedListId,status: true);
    }
    else if(_chooseQuestionType == Which.unlearned){
        _words = await DB.instance.readWordByLists(selectedListId,status: false);
    }
    else {
         _words = await DB.instance.readWordByLists(selectedListId);
    }

    if (_words.isNotEmpty) {
        if (_words.length > 3) {
           if (listMixed) _words.shuffle();

           Random random = Random();

           for (int i = 0; i < _words.length; i++) {
             clickControl.add(false);
             clickControlList.add([false,false,false,false]);

             List<String> tempOptions = [];
             while(true){
               int rand = random.nextInt(_words.length);
               if (rand != i) {
                 bool isThereSame = false;
                 for(var element in tempOptions){
                   if (chooseLang == Lang.english) {
                     if(element == _words[rand].word_tr!) {
                       isThereSame = true;
                     }
                   }
                   else {
                     if(element == _words[rand].word_eng!) {
                       isThereSame = true;
                     }
                   }
                 }

                 if(!isThereSame) {
                   tempOptions.add(chooseLang == Lang.english ? _words[rand].word_tr! : _words[rand].word_eng!);
                 }
               }

               if (tempOptions.length == 3) {
                 break;
               }
             }

             tempOptions.add(chooseLang == Lang.english ? _words[i].word_tr! : _words[i].word_eng!);
             tempOptions.shuffle();
             correctAnswers.add(chooseLang == Lang.english ? _words[i].word_tr! : _words[i].word_eng!);
             optionsList.add(tempOptions);
           }

           setState(() {
             start = true;
           });
        }
        else {
          toastMessage("minimum 4 kelime olması gerekli");
        }
    }
    else {
      toastMessage("Seçilen şartlarda liste boş");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !start ? Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 16,right: 16,bottom: 16),
          padding: const EdgeInsets.only(left: 4,top: 10,right: 4),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 219, 215, 209),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whichRadioButton(text: "Öğrenmediklerimi Sor",value: Which.unlearned),
              whichRadioButton(text: "Öğrendiklerimi Sor",value: Which.learn),
              whichRadioButton(text: "Hepsini Sor",value: Which.all),
              checkBox(text: "Listeyi karıştır",fWhat: forWhat.ForListMixed),
              SizedBox(height: 20,),
              const Divider(color:Colors.black, thickness: 2,),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text("Listeler",style: const TextStyle(fontSize: 18),),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 10),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Scrollbar(
                  thickness: 5,
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemBuilder: (context,index){
                      return checkBox(
                        text: _lists[index]['name'].toString(),
                        index: index
                      );
                    },
                    itemCount: _lists.length,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(right: 20),
                child: InkWell(
                  child: Text("Başla",style: const TextStyle(fontSize: 18,color: Colors.black),),
                  onTap: () {
                    List<int> selectedListIdList = [];
                    for (int i = 0; i < selectedListIndex.length; i++) {
                      if (selectedListIndex[i] == true) {
                        selectedListIdList.add(_lists[i]['list_id'] as int);
                      }
                    }
                    if (selectedListIdList.isNotEmpty) {
                      getSelectedWordOfLists(selectedListIdList);
                    }
                    else {
                      toastMessage("lütfen liste seç");
                    }
                  },
                ),
              )
            ],
          ),
        ) : _words.isEmpty ? Center(
          child: CircularProgressIndicator(),
        ) : CarouselSlider.builder(
          itemCount: _words.length,
          options: CarouselOptions(
            height: double.infinity
          ),
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        padding: const EdgeInsets.only(left: 4, top: 10, right: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                        duration: Duration(milliseconds: 200),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (chooseLang == Lang.english ? _words[itemIndex].word_eng! : _words[itemIndex].word_tr!),
                              style: TextStyle(fontSize: 28),
                            ),
                            customRadioButtonList(itemIndex, optionsList[itemIndex], correctAnswers[itemIndex])
                          ],
                        ),
                      ),
                      Positioned(
                        left: 30,
                        top: 10,
                        child: Text(
                          "${itemIndex + 1}/${_words.length}",
                          style: TextStyle(fontSize: 16)
                        ),
                      ),
                      Positioned(
                        right: 30,
                        top: 10,
                        child: Text(
                          "D: $correctCount / Y: $wrongCount",
                          style: TextStyle(fontSize: 16)
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: CheckboxListTile(
                    value: _words[itemIndex].status,
                    title: Text("Öğrenildi"),
                    onChanged: (value) {
                      _words[itemIndex] = _words[itemIndex].copy(status: value);
                      DB.instance.markAsLearned(value!, _words[itemIndex].id as int);
                      toastMessage(value ? "Öğrenildi olarak işaretlendi" : "Öğrenilmedi olarak işaretlendi");
                      setState(() {
                        _words[itemIndex];
                      });
                    }
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }


SizedBox whichRadioButton({@required String ?text , @required Which? value}){
  return SizedBox(
    width: 300,
    height: 35,
    child: ListTile(
      title: Text(text!,style: const TextStyle(fontSize: 18),),
      leading: Radio<Which> (
        value: value!,
        groupValue:_chooseQuestionType ,
        onChanged: (Which? value) {
            setState(() {
              _chooseQuestionType = value;
            });
        },
      ),
    ),
  );
}


SizedBox checkBox({int index=0,String ?text,forWhat fWhat=forWhat.forList}){
  return SizedBox(
    width: 300,
    height: 35,
    child: ListTile(
      title: Text(text!,style: TextStyle(fontSize: 18),),
      leading: Checkbox(
        checkColor: Colors.white,
        activeColor: Colors.deepPurpleAccent,
        hoverColor: Colors.blueAccent,
        value: fWhat==forWhat.forList? selectedListIndex[index]:listMixed,
        onChanged: (bool ?  value){
           setState(() {
              if (fWhat==forWhat.forList) {
              selectedListIndex[index]= value!;
            }
            else{
              listMixed = value!;
            }
           });
        },
      ),
    ),
  );
}



Container customRadioButton(int index , List<String> options , int order){
  Icon uncheck = const Icon(Icons.radio_button_off_outlined,size: 16,);
  Icon check = const Icon(Icons.radio_button_checked_outlined,size: 16,);
return Container(
  margin: const EdgeInsets.all(4),
  child: Row(
    children: [
     clickControlList[index][order]==false?uncheck:check,
     const SizedBox(width: 10),
     Text(options[order],style: const TextStyle(fontSize: 18),)
    ],
  ),
);

}



Column customRadioButtonList(int index, List<String> options, String correctAnswer){

Divider dV = Divider();
return Column(
  children: [
    InkWell(
      onTap: () => toastMessage("Seçmek için çift tıklayın"),
      onDoubleTap: () => checker(index,0,options,correctAnswer),
      child: customRadioButton(index, options, 0),
    ),
     InkWell(
      onTap: () => toastMessage("Seçmek için çift tıklayın"),
       onDoubleTap: () => checker(index,1,options,correctAnswer),
      child: customRadioButton(index, options, 1),
    ),
     InkWell(
      onTap: () => toastMessage("Seçmek için çift tıklayın"),
       onDoubleTap: () => checker(index,2,options,correctAnswer),
      child: customRadioButton(index, options, 2),
    ),
     InkWell(
      onTap: () => toastMessage("Seçmek için çift tıklayın"),
       onDoubleTap: () => checker(index,3,options,correctAnswer),
      child: customRadioButton(index, options, 3),
    ),
  ],

);

}



void checker(index,order,options, String correctAnswer){
  if (clickControl[index] == false) {
    clickControl[index] = true;
    setState(() {
      clickControlList[index][order] = true;
    });
  }

  if (options[order] == correctAnswer) {
    correctCount++;
  }
  else{
    wrongCount++;
  }


  if (correctCount+wrongCount == _words.length) {
    toastMessage("Test bitti");
  }




}


}