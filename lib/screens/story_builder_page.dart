import 'package:flutter/material.dart';
import 'package:english_word_app/services/story_service.dart';
import 'package:confetti/confetti.dart';

class StoryBuilderPage extends StatefulWidget {
  const StoryBuilderPage({super.key});

  @override
  State<StoryBuilderPage> createState() => _StoryBuilderPageState();
}

class _StoryBuilderPageState extends State<StoryBuilderPage> {
  final StoryService _storyService = StoryService();
  bool _isGameStarted = false;
  bool _isGameCompleted = false;
  String _selectedTheme = 'Macera';
  String _selectedDifficulty = 'Başlangıç';
  int _selectedLength = 3;
  List<String> _story = [];
  bool _isUserTurn = false;
  bool _isLoading = false;
  int _userScore = 0;
  int _aiScore = 0;
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 2));

  // Tema seçenekleri
  final List<String> _themes = [
    'Macera',
    'Bilim Kurgu',
    'Romantik',
    'Günlük Hayat',
    'Fantastik',
    'Gizem',
  ];

  // Zorluk seviyeleri
  final List<String> _difficulties = [
    'Başlangıç',
    'Orta',
    'İleri',
  ];

  // Hikaye uzunlukları
  final List<int> _lengths = [3, 5, 7];

  Future<void> _startGame() async {
    setState(() {
      _isGameStarted = true;
      _isGameCompleted = false;
      _story = [];
      _isUserTurn = false;
      _isLoading = true;
      _userScore = 0;
      _aiScore = 0;
    });

    try {
      final firstSentence = await _storyService.generateFirstSentence(
        theme: _selectedTheme,
        difficulty: _selectedDifficulty,
      );

      if (mounted) {
        setState(() {
          _story.add(firstSentence);
          _isUserTurn = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _story.add("Once upon a time, there was a brave knight who lived in a magical kingdom.");
          _isUserTurn = true;
          _isLoading = false;
        });
      }
    }
  }

  void _addUserSentence(String sentence) {
    if (sentence.trim().isEmpty) return;

    setState(() {
      _story.add(sentence);
      _isUserTurn = false;
      _isLoading = true;
    });

    // Cümle sayısını kontrol et
    if (_story.length >= _selectedLength * 2) {
      _completeGame();
      return;
    }

    // AI'dan yanıt al
    _storyService.generateStorySentence(
      theme: _selectedTheme,
      difficulty: _selectedDifficulty,
      previousSentences: _story,
    ).then((aiSentence) {
      if (mounted) {
        setState(() {
          _story.add(aiSentence);
          _isUserTurn = true;
          _isLoading = false;

          // Cümle sayısını tekrar kontrol et
          if (_story.length >= _selectedLength * 2) {
            _completeGame();
          }
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          _story.add("The story continues with an unexpected twist...");
          _isUserTurn = true;
          _isLoading = false;
        });
      }
    });
  }

  void _completeGame() {
    // Puanlama sistemi
    int userScore = 0;
    int aiScore = 0;

    // Kullanıcı cümlelerini değerlendir (basit bir örnek)
    for (int i = 1; i < _story.length; i += 2) {
      final userSentence = _story[i];
      // Cümle uzunluğu, kelime sayısı, noktalama işaretleri vb. kriterlere göre puan ver
      if (userSentence.length > 20) userScore += 2;
      if (userSentence.contains('.')) userScore += 1;
      if (userSentence.split(' ').length > 5) userScore += 2;
    }

    // AI cümlelerini değerlendir
    for (int i = 0; i < _story.length; i += 2) {
      final aiSentence = _story[i];
      if (aiSentence.length > 20) aiScore += 2;
      if (aiSentence.contains('.')) aiScore += 1;
      if (aiSentence.split(' ').length > 5) aiScore += 2;
    }

    setState(() {
      _isGameCompleted = true;
      _userScore = userScore;
      _aiScore = aiScore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Builder'),
        centerTitle: true,
      ),
      body: _isGameCompleted ? _buildCompletionUI() : 
             _isGameStarted ? _buildGameUI() : _buildStartUI(),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Widget _buildStartUI() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_stories,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const Text(
              'Story Builder',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            // Tema Seçimi
            DropdownButtonFormField<String>(
              value: _selectedTheme,
              decoration: const InputDecoration(
                labelText: 'Tema Seçin',
                border: OutlineInputBorder(),
              ),
              items: _themes.map((String theme) {
                return DropdownMenuItem<String>(
                  value: theme,
                  child: Text(theme),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTheme = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            // Zorluk Seviyesi
            DropdownButtonFormField<String>(
              value: _selectedDifficulty,
              decoration: const InputDecoration(
                labelText: 'Zorluk Seviyesi',
                border: OutlineInputBorder(),
              ),
              items: _difficulties.map((String difficulty) {
                return DropdownMenuItem<String>(
                  value: difficulty,
                  child: Text(difficulty),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedDifficulty = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            // Hikaye Uzunluğu
            DropdownButtonFormField<int>(
              value: _selectedLength,
              decoration: const InputDecoration(
                labelText: 'Hikaye Uzunluğu',
                border: OutlineInputBorder(),
              ),
              items: _lengths.map((int length) {
                return DropdownMenuItem<int>(
                  value: length,
                  child: Text('$length cümle'),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLength = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Oyuna Başla'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameUI() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _story.length,
            itemBuilder: (context, index) {
              final isAI = index % 2 == 0;
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Card(
                color: isAI ? Colors.blue.shade50 : Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isAI ? Icons.psychology : Icons.person,
                        color: isAI ? Colors.blue : Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _story[index],
                          style: TextStyle(fontSize: 16, color: isDark ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (_isUserTurn) _buildUserInput(),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  Widget _buildUserInput() {
    final TextEditingController controller = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Cümlenizi yazın...',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _addUserSentence(controller.text),
            icon: const Icon(Icons.send),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionUI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_confettiController.state != ConfettiControllerState.playing) _confettiController.play();
    });
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.celebration,
                  size: 64,
                  color: Colors.amber,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Hikaye Tamamlandı!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                // Puanlar
                Card(
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Sizin Puanınız: $_userScore',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'AI Puanı: $_aiScore',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Hikaye
                const Text(
                  'Hikayeniz:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._story.asMap().entries.map((entry) {
                  final index = entry.key;
                  final sentence = entry.value;
                  final isAI = index % 2 == 0;
                  return AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Card(
                      color: isAI ? Colors.blue.shade50 : Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              isAI ? Icons.psychology : Icons.person,
                              color: isAI ? Colors.blue : Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                sentence,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Yeni Hikaye Başlat'),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: [Colors.amber, Colors.green, Colors.blue, Colors.purple],
            numberOfParticles: 30,
            maxBlastForce: 20,
            minBlastForce: 8,
            emissionFrequency: 0.1,
            gravity: 0.2,
          ),
        ),
      ],
    );
  }
} 