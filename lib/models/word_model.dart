import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class WordCategory {
  final String name;
  final String icon;
  List<WordPair> words;

  WordCategory({
    required this.name,
    required this.icon,
    this.words = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'words': words.map((word) => word.toJson()).toList(),
    };
  }

  factory WordCategory.fromJson(Map<String, dynamic> json) {
    return WordCategory(
      name: json['name'],
      icon: json['icon'],
      words: (json['words'] as List)
          .map((word) => WordPair.fromJson(word))
          .toList(),
    );
  }
}

class WordPair {
  final String turkish;
  final String english;
  bool isLearned;
  DateTime lastReviewed;

  WordPair({
    required this.turkish,
    required this.english,
    this.isLearned = false,
    DateTime? lastReviewed,
  }) : lastReviewed = lastReviewed ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'turkish': turkish,
      'english': english,
      'isLearned': isLearned,
      'lastReviewed': lastReviewed.toIso8601String(),
    };
  }

  factory WordPair.fromJson(Map<String, dynamic> json) {
    return WordPair(
      turkish: json['turkish'],
      english: json['english'],
      isLearned: json['isLearned'],
      lastReviewed: DateTime.parse(json['lastReviewed']),
    );
  }
}

class WordStorage {
  static const String _categoriesKey = 'word_categories';
  static const String _statsKey = 'word_stats';

  static Future<void> saveCategories(List<WordCategory> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = categories.map((c) => jsonEncode(c.toJson())).toList();
    await prefs.setStringList(_categoriesKey, categoriesJson);
  }

  static Future<List<WordCategory>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = prefs.getStringList(_categoriesKey) ?? [];
    return categoriesJson
        .map((json) => WordCategory.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> saveStats(Map<String, dynamic> stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, jsonEncode(stats));
  }

  static Future<Map<String, dynamic>> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_statsKey);
    if (statsJson == null) {
      return {
        'totalWords': 0,
        'learnedWords': 0,
        'quizScores': [],
        'lastQuizDate': null,
        'streak': 0,
      };
    }
    return jsonDecode(statsJson);
  }
} 