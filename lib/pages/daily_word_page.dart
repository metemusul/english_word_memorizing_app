import 'package:english_word_app/colors/generallyColors.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'dart:math';

class DailyWordPage extends StatefulWidget {
  const DailyWordPage({super.key});

  @override
  State<DailyWordPage> createState() => _DailyWordPageState();
}

class _DailyWordPageState extends State<DailyWordPage> {
  final translator = GoogleTranslator();
  String dailyWord = "";
  String translation = "";
  bool isTurkish = true;
  final List<String> commonWords = [
    "hello", "world", "computer", "book", "friend", "family", "school", "work",
    "time", "day", "night", "food", "water", "house", "car", "phone", "music",
    "movie", "game", "sport", "art", "science", "math", "history", "language"
  ];

  @override
  void initState() {
    super.initState();
    _loadDailyWord();
  }

 Future<void> _loadDailyWord() async {
  final today = DateTime.now();
  final seed = today.year * 10000 + today.month * 100 + today.day;
  final random = Random(seed); // ✅ seed constructor içinde veriliyor

  final wordIndex = random.nextInt(commonWords.length);
  dailyWord = commonWords[wordIndex];

  final translationResult = await translator.translate(
    dailyWord,
    from: 'en',
    to: 'tr',
  );

  setState(() {
    translation = translationResult.text;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back_ios,color: firsColors.primaryBlackColor,size:22)
              )
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.5,
              margin: EdgeInsets.only(top: 10,left: 20),
              child: Text("Günün Kelimesi",style: TextStyle(color: Colors.black,fontFamily: "lucky",fontSize: 25),),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width*0.1,
              child: Image.asset("assets/images/small_logo.png"),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dil Seçimi: "),
                  Switch(
                    value: isTurkish,
                    onChanged: (value) {
                      setState(() {
                        isTurkish = value;
                      });
                    },
                  ),
                  Text(isTurkish ? "Türkçe" : "İngilizce"),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Card(
                  color: const Color.fromARGB(255, 241, 201, 141),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Bugünün Kelimesi",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: "robotomedium",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          isTurkish ? translation : dailyWord,
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: "robotomedium",
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          isTurkish ? dailyWord : translation,
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: "robotoregular",
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 