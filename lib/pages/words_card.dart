import 'package:english_word_app/db/db/db.dart';
import 'package:english_word_app/db/models/words.dart';
import 'package:english_word_app/global_variable.dart';
import 'package:english_word_app/global_widget/app_bar.dart';
import 'package:english_word_app/global_widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WordsCardPage extends StatefulWidget {
  const WordsCardPage({super.key});

  @override
  State<WordsCardPage> createState() => _WordsCardPageState();
}

enum Which {learn,unlearned,all}

enum forWhat {forList,ForListMixed}

class _WordsCardPageState extends State<WordsCardPage> {


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
  List<bool> changeLang = [];

  void getSelectedWordOfLists(List<int> selectedListId) async {
    // Önce mevcut listeleri temizleyelim
    _words = [];
    changeLang = [];

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
        for (int i = 0; i < _words.length; i++) {
            changeLang.add(true);
        }
        if (listMixed) _words.shuffle();
        
        setState(() {
            start = true;
        });
    }
    else {
        toastMessage("Seçilen şartlarda liste boş");
    }
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: appBar(
        context, 
        left: Icon(Icons.arrow_back_ios,color:Colors.black,size: 22,),
        center: Text("Kelime Kartları",style: TextStyle(fontFamily: "carter",color: Colors.black,fontSize: 22),),
        leftWidgetonClick:()=>Navigator.pop(context)
      ),
      body: SafeArea(
        child: !start ? Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 16,right: 16,bottom: 16),
          padding: const EdgeInsets.only(left: 4,top: 10,right: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whichRadioButton(text: "Öğrenmediklerimi Sor",value: Which.unlearned, isDark: isDark),
              whichRadioButton(text: "Öğrendiklerimi Sor",value: Which.learn, isDark: isDark),
              whichRadioButton(text: "Hepsini Sor",value: Which.all, isDark: isDark),
              checkBox(text: "Listeyi karıştır",fWhat: forWhat.ForListMixed, isDark: isDark),
              SizedBox(height: 20,),
              const Divider(color:Colors.black, thickness: 2,),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text("Listeler",style: TextStyle(fontSize: 18, color: isDark ? Colors.white : Colors.black)),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 10),
                height: 200,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Scrollbar(
                  thickness: 5,
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemBuilder: (context,index){
                      return checkBox(
                        text: _lists[index]['name'].toString(),
                        index: index,
                        isDark: isDark,
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
                  child: Text("Başla",style: TextStyle(fontSize: 18,color: isDark ? Colors.white : Colors.black),),
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
            String word = "";
            if (chooseLang == Lang.turkish) {
              word = changeLang[itemIndex] ? (_words[itemIndex].word_tr!) : (_words[itemIndex].word_eng!);
            }
            else {
              word = changeLang[itemIndex] ? (_words[itemIndex].word_eng!) : (_words[itemIndex].word_tr!);
            }
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      AnimatedScale(
                        scale: 1.0,
                        duration: Duration(milliseconds: 200),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              changeLang[itemIndex] = !changeLang[itemIndex];
                            });
                          },
                          child: Container(
                            child: Text(word, style: TextStyle(fontSize: 28, color: isDark ? Colors.white : Colors.black)),
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.only(left: 16,right: 16,bottom: 16),
                            padding: const EdgeInsets.only(left: 4,top: 10,right: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            )
                          ),
                        ),
                      ),
                      Positioned(child: Text((itemIndex+1).toString()+"/"+(_words.length).toString(),style: TextStyle(fontSize: 16, color: isDark ? Colors.white : Colors.black)),left: 30,top: 10,)
                    ],
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: CheckboxListTile(
                    value:_words[itemIndex].status,
                    title: Text("Öğrenildi", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                    onChanged: (value){
                      _words[itemIndex] = _words[itemIndex].copy(status: value);
                      DB.instance.markAsLearned(value!,_words[itemIndex].id as int);
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


SizedBox whichRadioButton({@required String ?text , @required Which? value, bool isDark = false}){
  return SizedBox(
    width: 300,
    height: 35,
    child: ListTile(
      title: Text(text!,style: TextStyle(fontSize: 18, color: isDark ? Colors.white : Colors.black)),
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


SizedBox checkBox({int index=0,String ?text,forWhat fWhat=forWhat.forList, bool isDark = false}){
  return SizedBox(
    width: 300,
    height: 35,
    child: ListTile(
      title: Text(text!,style: TextStyle(fontSize: 18, color: isDark ? Colors.white : Colors.black)),
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



}