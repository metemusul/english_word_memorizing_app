import 'package:english_word_app/pages/lists_page.dart';
import 'package:english_word_app/pages/daily_word_page.dart';
import 'package:english_word_app/pages/quiz_page.dart';
import 'package:english_word_app/pages/stats_page.dart';
import 'package:english_word_app/pages/badges_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kelime Ezberleme Uygulaması',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelime Ezberleme'),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildMenuCard(
            context,
            'Kelime Listesi',
            Icons.list,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ListsPage()),
            ),
          ),
          _buildMenuCard(
            context,
            'Günün Kelimesi',
            Icons.today,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DailyWordPage()),
            ),
          ),
          _buildMenuCard(
            context,
            'Quiz',
            Icons.quiz,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuizPage()),
            ),
          ),
          _buildMenuCard(
            context,
            'İstatistikler',
            Icons.bar_chart,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StatsPage()),
            ),
          ),
          _buildMenuCard(
            context,
            'Rozetler',
            Icons.emoji_events,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BadgesPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




