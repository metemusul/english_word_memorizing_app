import 'package:english_word_app/colors/generallyColors.dart';
import 'package:english_word_app/models/word_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  Map<String, dynamic> stats = {};
  List<WordCategory> categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedStats = await WordStorage.loadStats();
    final loadedCategories = await WordStorage.loadCategories();
    setState(() {
      stats = loadedStats;
      categories = loadedCategories;
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
              child: Text("İstatistikler",style: TextStyle(color: Colors.black,fontFamily: "lucky",fontSize: 25),),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsCard(),
              SizedBox(height: 20),
              _buildProgressChart(),
              SizedBox(height: 20),
              _buildCategoryStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      color: const Color.fromARGB(255, 241, 201, 141),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Genel İstatistikler",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildStatRow("Toplam Kelime", "${stats['totalWords'] ?? 0}"),
            _buildStatRow("Öğrenilen Kelime", "${stats['learnedWords'] ?? 0}"),
            _buildStatRow("Quiz Skoru", "${stats['quizScores']?.last ?? 0}/10"),
            _buildStatRow("Seri", "${stats['streak'] ?? 0} gün"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart() {
    final totalWords = stats['totalWords'] ?? 0;
    final learnedWords = stats['learnedWords'] ?? 0;
    final progress = totalWords > 0 ? learnedWords / totalWords : 0.0;

    return Card(
      color: const Color.fromARGB(255, 241, 201, 141),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "İlerleme Durumu",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: progress * 100,
                      title: "${(progress * 100).toStringAsFixed(1)}%",
                      color: Colors.green,
                      radius: 100,
                      titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: (1 - progress) * 100,
                      title: "${((1 - progress) * 100).toStringAsFixed(1)}%",
                      color: Colors.grey,
                      radius: 100,
                      titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryStats() {
    return Card(
      color: const Color.fromARGB(255, 241, 201, 141),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kategori İstatistikleri",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...categories.map((category) => _buildCategoryRow(category)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(WordCategory category) {
    final totalWords = category.words.length;
    final learnedWords = category.words.where((w) => w.isLearned).length;
    final progress = totalWords > 0 ? learnedWords / totalWords : 0.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                "$learnedWords/$totalWords",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ],
      ),
    );
  }
} 