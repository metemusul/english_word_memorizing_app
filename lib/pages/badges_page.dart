import 'package:english_word_app/colors/generallyColors.dart';
import 'package:english_word_app/models/word_model.dart';
import 'package:flutter/material.dart';

class Badge {
  final String name;
  final String description;
  final String iconPath;
  final bool isUnlocked;
  final int progress;
  final int target;

  Badge({
    required this.name,
    required this.description,
    required this.iconPath,
    required this.isUnlocked,
    required this.progress,
    required this.target,
  });
}

class BadgesPage extends StatefulWidget {
  const BadgesPage({super.key});

  @override
  State<BadgesPage> createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage> {
  List<Badge> badges = [];
  Map<String, dynamic> stats = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedStats = await WordStorage.loadStats();
    setState(() {
      stats = loadedStats;
      _initializeBadges();
    });
  }

  void _initializeBadges() {
    final totalWords = stats['totalWords'] ?? 0;
    final learnedWords = stats['learnedWords'] ?? 0;
    final quizScores = stats['quizScores'] as List? ?? [];
    final streak = stats['streak'] ?? 0;

    badges = [
      Badge(
        name: "Başlangıç",
        description: "İlk kelimeyi ekle",
        iconPath: "assets/badges/beginner.png",
        isUnlocked: totalWords > 0,
        progress: totalWords,
        target: 1,
      ),
      Badge(
        name: "Kelime Ustası",
        description: "100 kelime öğren",
        iconPath: "assets/badges/master.png",
        isUnlocked: learnedWords >= 100,
        progress: learnedWords,
        target: 100,
      ),
      Badge(
        name: "Quiz Şampiyonu",
        description: "10/10 quiz skoru al",
        iconPath: "assets/badges/quiz.png",
        isUnlocked: quizScores.contains(10),
        progress: quizScores.isNotEmpty ? quizScores.last : 0,
        target: 10,
      ),
      Badge(
        name: "Tutarlı Öğrenci",
        description: "7 gün üst üste çalış",
        iconPath: "assets/badges/streak.png",
        isUnlocked: streak >= 7,
        progress: streak,
        target: 7,
      ),
    ];
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
              child: Text("Rozetler",style: TextStyle(color: Colors.black,fontFamily: "lucky",fontSize: 25),),
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
        child: GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            final badge = badges[index];
            return _buildBadgeCard(badge);
          },
        ),
      ),
    );
  }

  Widget _buildBadgeCard(Badge badge) {
    return Card(
      color: const Color.fromARGB(255, 241, 201, 141),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              badge.iconPath,
              width: 64,
              height: 64,
              color: badge.isUnlocked ? null : Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              badge.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              badge.description,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: badge.progress / badge.target,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                badge.isUnlocked ? Colors.green : Colors.orange,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "${badge.progress}/${badge.target}",
              style: TextStyle(
                fontSize: 12,
                fontFamily: "robotoregular",
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 