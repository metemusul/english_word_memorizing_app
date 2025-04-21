import 'package:english_word_app/colors/generallyColors.dart';
import 'package:english_word_app/models/word_model.dart'; // ✅ Doğru model import'u
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  final translator = GoogleTranslator();
  final flutterTts = FlutterTts();
  List<WordCategory> categories = [];
  WordCategory? selectedCategory;
  bool isTurkish = true;
  TextEditingController wordController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> _loadCategories() async {
    final loadedCategories = await WordStorage.loadCategories();
    setState(() {
      categories = loadedCategories;
      if (categories.isEmpty) {
        categories.add(WordCategory(
          name: "Genel",
          icon: "📚",
          words: [],
        ));
      }
      selectedCategory = categories.first;
    });
  }

  Future<void> _speak(String text, String language) async {
    await flutterTts.setLanguage(language);
    await flutterTts.speak(text);
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
              child: Text(capitalizeFirstLetter("Kelime Listesi"),style: TextStyle(color: Colors.black,fontFamily: "lucky",fontSize: 25),),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width*0.1,
              child: Image.asset("assets/images/small_logo.png"),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _showAddCategoryDialog(),
            child: Icon(Icons.folder_open, color: firsColors.primaryWhiteColor),
            backgroundColor: Colors.blue,
            heroTag: "addCategory",
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _showAddWordDialog(),
            child: Icon(Icons.add, color: firsColors.primaryWhiteColor),
            backgroundColor: const Color.fromARGB(255, 233, 132, 16),
            heroTag: "addWord",
          ),
        ],
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
            if (categories.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<WordCategory>(
                  value: selectedCategory,
                  isExpanded: true,
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text("${category.icon} ${category.name}"),
                    );
                  }).toList(),
                  onChanged: (category) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: selectedCategory?.words.length ?? 0,
                itemBuilder: (context, index) {
                  final word = selectedCategory!.words[index];
                  return Card(
                    color: const Color.fromARGB(255, 241, 201, 141),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(
                        isTurkish ? word.turkish : word.english,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        isTurkish ? word.english : word.turkish,
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.volume_up),
                            onPressed: () => _speak(
                              isTurkish ? word.turkish : word.english,
                              isTurkish ? "tr-TR" : "en-US"
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                selectedCategory!.words.removeAt(index);
                                WordStorage.saveCategories(categories);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }

  Future<void> _showAddCategoryDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Yeni Kategori Ekle"),
          content: TextField(
            controller: categoryController,
            decoration: InputDecoration(
              hintText: "Kategori adı girin",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("İptal"),
            ),
            TextButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  setState(() {
                    categories.add(WordCategory(
                      name: categoryController.text,
                      icon: "📚",
                      words: [],
                    ));
                    WordStorage.saveCategories(categories);
                  });
                  categoryController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text("Ekle"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddWordDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Yeni Kelime Ekle"),
          content: TextField(
            controller: wordController,
            decoration: InputDecoration(
              hintText: isTurkish ? "Türkçe kelime girin" : "Enter English word",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("İptal"),
            ),
            TextButton(
              onPressed: () async {
                if (wordController.text.isNotEmpty) {
                  Translation translation;
                  if (isTurkish) {
                    translation = await translator.translate(
                      wordController.text,
                      from: 'tr',
                      to: 'en'
                    );
                  } else {
                    translation = await translator.translate(
                      wordController.text,
                      from: 'en',
                      to: 'tr'
                    );
                  }
                  
                  setState(() {
                    if (isTurkish) {
                      selectedCategory!.words.add(WordPair(
                        turkish: wordController.text,
                        english: translation.text
                      ));
                    } else {
                      selectedCategory!.words.add(WordPair(
                        turkish: translation.text,
                        english: wordController.text
                      ));
                    }
                    WordStorage.saveCategories(categories);
                  });
                  wordController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text("Ekle"),
            ),
          ],
        );
      },
    );
  }
}



String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}