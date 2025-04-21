import 'package:english_word_app/colors/generallyColors.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'dart:math';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final translator = GoogleTranslator();
  String currentWord = "";
  String correctTranslation = "";
  List<String> options = [];
  int score = 0;
  int questionCount = 0;
  bool isTurkish = true;
  final List<String> commonWords = [
    "hello", "world", "computer", "book", "friend", "family", "school", "work",
    "time", "day", "night", "food", "water", "house", "car", "phone", "music",
    "movie", "game", "sport", "art", "science", "math", "history", "language"
  ];

  @override
  void initState() {
    super.initState();
    _loadNewQuestion();
  }

  Future<void> _loadNewQuestion() async {
    if (questionCount >= 10) {
      _showResults();
      return;
    }

    final random = Random();
    final wordIndex = random.nextInt(commonWords.length);
    currentWord = commonWords[wordIndex];
    
    final translationResult = await translator.translate(
      currentWord,
      from: 'en',
      to: 'tr'
    );
    
    correctTranslation = translationResult.text;
    
    // Generate 3 random wrong options
    options = [correctTranslation];
    while (options.length < 4) {
      final wrongWordIndex = random.nextInt(commonWords.length);
      if (wrongWordIndex != wordIndex) {
        final wrongTranslation = await translator.translate(
          commonWords[wrongWordIndex],
          from: 'en',
          to: 'tr'
        );
        if (!options.contains(wrongTranslation.text)) {
          options.add(wrongTranslation.text);
        }
      }
    }
    
    options.shuffle();
    
    setState(() {
      questionCount++;
    });
  }

  void _checkAnswer(String selectedAnswer) {
    if (selectedAnswer == correctTranslation) {
      setState(() {
        score++;
      });
    }
    _loadNewQuestion();
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Quiz Tamamlandı!"),
          content: Text("Skorunuz: $score/10"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  score = 0;
                  questionCount = 0;
                });
                _loadNewQuestion();
              },
              child: Text("Tekrar Başla"),
            ),
          ],
        );
      },
    );
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
              child: Text("Quiz",style: TextStyle(color: Colors.black,fontFamily: "lucky",fontSize: 25),),
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
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Soru: $questionCount/10"),
                  Text("Skor: $score"),
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
                          isTurkish ? "Bu kelimenin Türkçesi nedir?" : "What is the English translation?",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: "robotomedium",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          isTurkish ? currentWord : correctTranslation,
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: "robotomedium",
                          ),
                        ),
                        SizedBox(height: 40),
                        ...options.map((option) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () => _checkAnswer(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontFamily: "robotoregular",
                              ),
                            ),
                          ),
                        )).toList(),
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