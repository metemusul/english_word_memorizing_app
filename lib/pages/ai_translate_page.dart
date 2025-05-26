import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class AiTranslatePage extends StatefulWidget {
  const AiTranslatePage({Key? key}) : super(key: key);

  @override
  State<AiTranslatePage> createState() => _AiTranslatePageState();
}

class _AiTranslatePageState extends State<AiTranslatePage> {
  final List<String> exams = [
    'YKS',
    'DGS',
    'YDS',
    'DUS',
    'E-YDS',
    'YÖKDİL',
    'ALES',
    'YÖS',
  ];
  String? selectedExam;
  bool isLoading = false;
  String? paragraph;
  String? translation;
  String? error;
  bool showTranslation = false;
  final TextEditingController userTranslationController = TextEditingController();

  Future<void> _generateParagraph() async {
    setState(() {
      isLoading = true;
      paragraph = null;
      translation = null;
      error = null;
      showTranslation = false;
      userTranslationController.clear();
    });
    try {
      final result = await AiService.generateExamParagraph(selectedExam!);
      setState(() {
        paragraph = result['paragraph'];
        translation = result['translation'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    userTranslationController.dispose();
    super.dispose();
  }

  String fixTurkishChars(String text) {
    return text
        .replaceAll('c', 'ç')
        .replaceAll('C', 'Ç')
        .replaceAll('g', 'ğ')
        .replaceAll('G', 'Ğ')
        .replaceAll('i', 'ı')
        .replaceAll('I', 'İ')
        .replaceAll('o', 'ö')
        .replaceAll('O', 'Ö')
        .replaceAll('s', 'ş')
        .replaceAll('S', 'Ş')
        .replaceAll('u', 'ü')
        .replaceAll('U', 'Ü');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Paragraf Çeviri'),
        backgroundColor: Colors.orange.shade700,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sınav Seçiniz:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              ...exams.map((exam) => RadioListTile<String>(
                    title: Text(exam),
                    value: exam,
                    groupValue: selectedExam,
                    onChanged: (value) {
                      setState(() {
                        selectedExam = value;
                      });
                    },
                  )),
              SizedBox(height: 32),
              if (isLoading)
                Center(child: CircularProgressIndicator()),
              if (error != null)
                Center(child: Text(error!, style: TextStyle(color: Colors.red))),
              if (!isLoading && paragraph == null && error == null)
                Center(
                  child: ElevatedButton(
                    onPressed: selectedExam == null ? null : _generateParagraph,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Paragraf Oluştur', style: TextStyle(fontSize: 18)),
                  ),
                ),
              if (paragraph != null)
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  child: Column(
                    key: ValueKey(paragraph),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('İngilizce Paragraf:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      AnimatedScale(
                        scale: 1.0,
                        duration: Duration(milliseconds: 200),
                        child: Card(
                          color: Theme.of(context).cardColor,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(paragraph!, style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text('Çevirini Yaz:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      TextField(
                        controller: userTranslationController,
                        minLines: 3,
                        maxLines: 6,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        enableSuggestions: true,
                        autocorrect: true,
                        style: TextStyle(fontFamily: "Roboto", fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Kendi Türkçe çevirini buraya yaz...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showTranslation = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text('Çeviriyi Göster', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: showTranslation
                            ? AnimatedScale(
                                scale: 1.0,
                                duration: Duration(milliseconds: 200),
                                child: Card(
                                  color: Theme.of(context).cardColor,
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Doğru Türkçe Çeviri:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[900])),
                                        SizedBox(height: 8),
                                        Text(fixTurkishChars(translation ?? ''), style: TextStyle(fontSize: 16, color: Colors.green[900])),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 