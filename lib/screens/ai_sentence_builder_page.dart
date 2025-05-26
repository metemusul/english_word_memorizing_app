import 'package:flutter/material.dart';
import 'package:english_word_app/services/story_service.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AISentenceBuilderPage extends StatefulWidget {
  const AISentenceBuilderPage({super.key});

  @override
  State<AISentenceBuilderPage> createState() => _AISentenceBuilderPageState();
}

class _AISentenceBuilderPageState extends State<AISentenceBuilderPage> {
  final StoryService _storyService = StoryService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isGameStarted = false;
  bool _isGameCompleted = false;
  String _selectedDifficulty = 'Başlangıç';
  List<String> _scrambledWords = [];
  List<String> _userSentenceWords = [];
  String _correctSentence = '';
  String? _turkishTranslation; // Yeni: Türkçe çeviri
  bool _isLoading = false;
  int _score = 0;
  int _attempts = 0;
  int _level = 1;
  int _consecutiveSuccess = 0;
  final int _maxAttempts = 3;

  // Zorluk seviyeleri
  final List<String> _difficulties = [
    'Başlangıç',
    'Orta',
    'İleri',
  ];

  // Örnek cümleler (zorluk seviyelerine göre)
  final Map<String, List<String>> _exampleSentences = {
    'Başlangıç': [
      'I love reading books.',
      'She plays the piano.',
      'They live in London.',
      'We study English.',
      'He works every day.',
    ],
    'Orta': [
      'The beautiful garden is full of colorful flowers.',
      'She carefully prepared the delicious dinner.',
      'They successfully completed the difficult project.',
      'The young student eagerly learned new words.',
      'We happily celebrated the special occasion.',
    ],
    'İleri': [
      'Despite the challenging circumstances, they managed to achieve their goals successfully.',
      'The innovative technology has significantly improved our daily lives.',
      'She enthusiastically participated in the international conference.',
      'The environmental scientists carefully analyzed the complex data.',
      'We should consider implementing sustainable solutions for future generations.',
    ],
  };

  // Basit İngilizce-Türkçe sözlük
  final Map<String, String> _simpleDictionary = {
    'I': 'Ben',
    'love': 'sevmek',
    'reading': 'okumak',
    'books': 'kitaplar',
    'She': 'O (kadın)',
    'plays': 'çalmak/oynamak',
    'the': '',
    'piano': 'piyano',
    'They': 'Onlar',
    'live': 'yaşamak',
    'in': 'içinde',
    'London': 'Londra',
    'We': 'Biz',
    'study': 'ders çalışmak',
    'English': 'İngilizce',
    'He': 'O (erkek)',
    'works': 'çalışmak',
    'every': 'her',
    'day': 'gün',
    'The': '',
    'beautiful': 'güzel',
    'garden': 'bahçe',
    'is': '-dır/-dir',
    'full': 'dolu',
    'of': '-nın',
    'colorful': 'renkli',
    'flowers': 'çiçekler',
    'carefully': 'dikkatlice',
    'prepared': 'hazırladı',
    'delicious': 'lezzetli',
    'dinner': 'akşam yemeği',
    'successfully': 'başarıyla',
    'completed': 'tamamladı',
    'difficult': 'zor',
    'project': 'proje',
    'young': 'genç',
    'student': 'öğrenci',
    'eagerly': 'istekli bir şekilde',
    'learned': 'öğrendi',
    'new': 'yeni',
    'words': 'kelimeler',
    'happily': 'mutlu bir şekilde',
    'celebrated': 'kutladı',
    'special': 'özel',
    'occasion': 'gün',
    'Despite': '-e rağmen',
    'challenging': 'zorlu',
    'circumstances': 'koşullar',
    'they': 'onlar',
    'managed': 'başardı',
    'to': '-mek/-mak',
    'achieve': 'başarmak',
    'their': 'onların',
    'goals': 'hedefler',
    'successfully': 'başarıyla',
    'innovative': 'yenilikçi',
    'technology': 'teknoloji',
    'has': 'sahip',
    'significantly': 'önemli ölçüde',
    'improved': 'geliştirdi',
    'our': 'bizim',
    'daily': 'günlük',
    'lives': 'hayatlar',
    'enthusiastically': 'hevesle',
    'participated': 'katıldı',
    'international': 'uluslararası',
    'conference': 'konferans',
    'environmental': 'çevresel',
    'scientists': 'bilim insanları',
    'carefully': 'dikkatlice',
    'analyzed': 'analiz etti',
    'complex': 'karmaşık',
    'data': 'veri',
    'should': '-meli/-malı',
    'consider': 'düşünmek',
    'implementing': 'uygulamak',
    'sustainable': 'sürdürülebilir',
    'solutions': 'çözümler',
    'for': 'için',
    'future': 'gelecek',
    'generations': 'nesiller',
  };

  // OpenRouter API key
  static const String _openRouterApiKey = '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';

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(bool success) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(success ? 'sounds/success.mp3' : 'sounds/fail.mp3'));
    } catch (e) {
      // ignore errors silently
    }
  }

  void _startGame() {
    setState(() {
      _isGameStarted = true;
      _isGameCompleted = false;
      _isLoading = false;
      _attempts = 0;
      _score = 0;
      _turkishTranslation = null;
    });

    _generateNewSentence();
  }

  void _generateNewSentence() {
    setState(() {
      _isLoading = true;
    });

    // Örnek cümlelerden rastgele bir tane seç
    final sentences = _exampleSentences[_selectedDifficulty]!;
    _correctSentence = sentences[DateTime.now().millisecondsSinceEpoch % sentences.length];

    // Kelimeleri karıştır
    final words = _correctSentence
        .replaceAll(RegExp(r'[.,!?]'), '') // Noktalama işaretlerini kaldır
        .split(' ')
        .toList();
    _scrambledWords = List<String>.from(words)..shuffle();
    _userSentenceWords = [];

    setState(() {
      _isLoading = false;
    });
  }

  Future<String?> _fetchTurkishTranslation(String englishSentence) async {
    try {
      final uri = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
      final headers = {
        'Authorization': 'Bearer $_openRouterApiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'english-word-app',
        'X-Title': 'english-word-app',
      };
      final prompt =
          'Translate the following sentence from English to Turkish. Only return the Turkish translation, do not add any explanation.\n\nSentence: "$englishSentence"';
      final body = {
        'model': 'mistralai/mistral-large',
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'max_tokens': 100,
        'temperature': 0.2,
      };
      final response = await http.post(uri, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String?;
        return content?.trim();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _checkAnswer() async {
    setState(() {
      _attempts++;
    });

    final userSentence = _userSentenceWords.join(' ').toLowerCase().trim();
    final correctSentence = _correctSentence
        .replaceAll(RegExp(r'[.,!?]'), '')
        .toLowerCase()
        .trim();

    if (userSentence == correctSentence) {
      setState(() {
        _score += 10;
        _isGameCompleted = true;
        _level++;
        _consecutiveSuccess++;
      });
      await _playSound(true);
      HapticFeedback.lightImpact();
      // Türkçe çeviri isteği (OpenRouter API)
      setState(() {
        _turkishTranslation = null;
      });
      final translation = await _fetchTurkishTranslation(_correctSentence);
      setState(() {
        _turkishTranslation = translation ?? '(Çeviri alınamadı)';
      });
    } else if (_attempts >= _maxAttempts) {
      setState(() {
        _isGameCompleted = true;
        _consecutiveSuccess = 0;
      });
      await _playSound(false);
      HapticFeedback.vibrate();
    } else {
      await _playSound(false);
      HapticFeedback.mediumImpact();
    }
  }

  void _resetGame() {
    setState(() {
      _isGameStarted = false;
      _isGameCompleted = false;
      _scrambledWords = [];
      _userSentenceWords = [];
      _correctSentence = '';
      _turkishTranslation = null;
      _score = 0;
      _attempts = 0;
    });
  }

  void _moveWordToSentence(String word) {
    setState(() {
      _scrambledWords.remove(word);
      _userSentenceWords.add(word);
    });
    HapticFeedback.selectionClick();
  }

  void _moveWordToScrambled(String word) {
    setState(() {
      _userSentenceWords.remove(word);
      _scrambledWords.add(word);
    });
    HapticFeedback.selectionClick();
  }

  int _calculateStars() {
    if (_attempts == 1) return 3;
    if (_attempts == 2) return 2;
    return 1;
  }

  void _showWordMeaning(BuildContext context, String word) {
    final cleanWord = word.replaceAll(RegExp(r'[.,!?]'), '');
    final meaning = _simpleDictionary[cleanWord] ?? 'Çeviri bulunamadı';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('"$cleanWord"'),
        content: Text(meaning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3F0FF), Color(0xFFFDF6E3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('AI Cümle Kurucu',style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.blue.shade100.withOpacity(0.7),
          elevation: 0,
        ),
        body: _isGameCompleted ? _buildCompletionUI() :
               _isGameStarted ? _buildGameUI() : _buildStartUI(),
      ),
    );
  }

  Widget _buildStartUI() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.psychology,
              size: 64,
              color: Colors.purple,
            ),
            const SizedBox(height: 24),
            Text(
              'AI Cümle Kurucu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color:  Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            // Zorluk Seviyesi
            Theme(
              data: Theme.of(context).copyWith(
                canvasColor: isDark ? Colors.grey[900] : null,
                textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: isDark ? Colors.white : Colors.black,
                  displayColor: isDark ? Colors.white : Colors.black,
                ),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: InputDecoration(
                  labelText: 'Zorluk Seviyesi',
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black),
                ),
                dropdownColor: isDark ? Colors.grey[900] : null,
                items: _difficulties.map((String difficulty) {
                  return DropdownMenuItem<String>(
                    value: difficulty,
                    child: Text(
                      difficulty,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
                selectedItemBuilder: (context) {
                  return _difficulties.map((difficulty) {
                    return Text(
                      difficulty,
                      style: TextStyle(color: Colors.black),
                    );
                  }).toList();
                },
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedDifficulty = newValue;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.blue.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Oyuna Başla'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameUI() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Seviye ve Yıldızlar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                  const SizedBox(width: 4),
                  Text('Seviye $_level', style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 18)),
                ],
              ),
              Row(
                children: List.generate(3, (i) => Icon(Icons.star, color: Colors.amber.withOpacity(i < _calculateStars() ? 1 : 0.2), size: 28)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Skor ve Deneme Sayısı
          Card(
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Skor: $_score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    'Deneme: $_attempts/$_maxAttempts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Karışık Kelimeler Alanı
          Text(
            'Karışık Kelimeler:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color:  Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.blueGrey[900] : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
              boxShadow: [BoxShadow(color: Colors.blue.shade100, blurRadius: 4, offset: Offset(0,2))],
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _scrambledWords.map((word) {
                return Draggable<String>(
                  data: word,
                  feedback: Material(
                    color: Colors.transparent,
                    child: _buildWordCard(word, isDragging: true, isDark: isDark),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.5,
                    child: _buildWordCard(word, isDark: isDark),
                  ),
                  child: _buildWordCard(word, isDark: isDark),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 32),
          // Cümle Alanı (Boş Alan)
          Text(
            'Cümleniz:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color:  Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          DragTarget<String>(
            onWillAccept: (data) => true,
            onAccept: (word) {
              _moveWordToSentence(word);
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                padding: const EdgeInsets.all(8),
                height: 60,
                decoration: BoxDecoration(
                  color: isDark ? Colors.green[900] : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                  boxShadow: [BoxShadow(color: Colors.green.shade100, blurRadius: 4, offset: Offset(0,2))],
                ),
                child: _userSentenceWords.isEmpty
                    ? Center(child: Text('Buraya kelimeleri sürükleyin', style: TextStyle(color: isDark ? Colors.white : Colors.black)))
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _userSentenceWords.map((word) {
                          return Draggable<String>(
                            data: word,
                            feedback: Material(
                              color: Colors.transparent,
                              child: _buildWordCard(word, isDragging: true, isSentence: true, isDark: isDark),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.5,
                              child: _buildWordCard(word, isSentence: true, isDark: isDark),
                            ),
                            child: DragTarget<String>(
                              onWillAccept: (data) => true,
                              onAccept: (draggedWord) {
                                if (draggedWord != word) {
                                  setState(() {
                                    _userSentenceWords.remove(draggedWord);
                                    int insertIndex = _userSentenceWords.indexOf(word);
                                    _userSentenceWords.insert(insertIndex, draggedWord);
                                  });
                                }
                              },
                              builder: (context, candidateData, rejectedData) {
                                return GestureDetector(
                                  onDoubleTap: () {
                                    _moveWordToScrambled(word);
                                  },
                                  child: _buildWordCard(word, isSentence: true, isDark: isDark),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
              );
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _userSentenceWords.isNotEmpty ? _checkAnswer : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.green.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Kontrol Et'),
          ),
          const SizedBox(height: 8),
          Text(
            'İpucu: Kelimeleri cümle alanına sürükleyin. Yanlış eklediğiniz kelimeyi çift tıklayarak geri gönderebilirsiniz.',
            style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard(String word, {bool isDragging = false, bool isSentence = false, bool isDark = false}) {
    return GestureDetector(
      onLongPress: () => _showWordMeaning(context, word),
      child: AnimatedScale(
        scale: isDragging ? 1.0 : 1.0,
        duration: Duration(milliseconds: 200),
        child: Card(
          color: isDark
              ? (isSentence ? Colors.green[800] : Colors.blueGrey[800])
              : (isSentence ? Colors.green.shade100 : Colors.blue.shade100),
          elevation: isDragging ? 8 : 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              word,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : (isSentence ? Colors.green.shade900 : Colors.blue.shade900),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionUI() {
    final userSentence = _userSentenceWords.join(' ').toLowerCase().trim();
    final correctSentence = _correctSentence
        .replaceAll(RegExp(r'[.,!?]'), '')
        .toLowerCase()
        .trim();
    final isCorrect = userSentence == correctSentence;
    final stars = _calculateStars();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              size: 64,
              color: isCorrect ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => Icon(Icons.star, color: Colors.amber.withOpacity(i < stars ? 1 : 0.2), size: 32)),
            ),
            const SizedBox(height: 8),
            Text(
              isCorrect ? 'Tebrikler!' : 'Tekrar Deneyin',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Seviye ve Rozet
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                const SizedBox(width: 4),
                Text('Seviye $_level', style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 18)),
                if (_consecutiveSuccess >= 5) ...[
                  const SizedBox(width: 12),
                  const Icon(Icons.workspace_premium, color: Colors.deepPurple, size: 28),
                  const Text('Rozet!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                ]
              ],
            ),
            const SizedBox(height: 24),
            // Doğru Cümle
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Doğru Cümle:',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _correctSentence,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Türkçe Çeviri
            if (_turkishTranslation != null)
              Card(
                color: Colors.yellow.shade50,
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Türkçesi:',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _turkishTranslation!,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.brown,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            // Skor
            Text(
              'Skorunuz: $_score',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _resetGame,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.blue.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Yeni Oyun'),
            ),
          ],
        ),
      ),
    );
  }
} 