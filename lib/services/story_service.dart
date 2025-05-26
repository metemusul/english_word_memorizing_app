import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class StoryService {
  static const String _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String _apiKey = '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';

  static const Duration _timeout = Duration(seconds: 10);

  Future<String> generateStorySentence({
    required String theme,
    required String difficulty,
    required List<String> previousSentences,
  }) async {
    try {
      print('Generating story sentence...');
      print('Theme: $theme, Difficulty: $difficulty');
      
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://englishwordapp.com',
          'X-Title': 'English Word App',
        },
        body: jsonEncode({
          'model': 'anthropic/claude-3-opus',
          'messages': [
            {
              'role': 'system',
              'content': '''You are a creative story writer. 
              Write a single sentence in English that continues the story.
              Theme: $theme
              Difficulty: $difficulty
              Previous sentences: ${previousSentences.join(' ')}'''
            }
          ],
          'temperature': 0.7,
          'max_tokens': 100,
        }),
      ).timeout(_timeout);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        print('Error response: ${response.body}');
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      print('Network error: $e');
      return "I'm having trouble connecting to the story server. Please check your internet connection and try again.";
    } on Exception catch (e) {
      print('Exception caught: $e');
      return "Sorry, I couldn't continue the story right now. Please try again.";
    }
  }

  Future<String> generateFirstSentence({
    required String theme,
    required String difficulty,
  }) async {
    try {
      print('Generating first sentence...');
      print('Theme: $theme, Difficulty: $difficulty');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://englishwordapp.com',
          'X-Title': 'English Word App',
        },
        body: jsonEncode({
          'model': 'anthropic/claude-3-opus',
          'messages': [
            {
              'role': 'system',
              'content': '''You are a creative story writer. 
              Write an engaging first sentence in English for a story.
              Theme: $theme
              Difficulty: $difficulty
              Make it interesting and appropriate for the theme.'''
            }
          ],
          'temperature': 0.7,
          'max_tokens': 100,
        }),
      ).timeout(_timeout);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        print('Error response: ${response.body}');
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      print('Network error: $e');
      return "I'm having trouble connecting to the story server. Please check your internet connection and try again.";
    } on Exception catch (e) {
      print('Exception caught: $e');
      return "Once upon a time, in a world full of possibilities...";
    }
  }
} 