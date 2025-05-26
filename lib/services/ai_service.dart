import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  static const String _apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String _apiKey = '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';

  static Future<Map<String, String>> generateExamParagraph(String examType) async {
    final prompt = '''
Write a random, medium-length English paragraph suitable for the $examType exam. Then, provide its correct and fluent Turkish translation. 
In the Turkish translation, strictly use the correct Turkish alphabet (ç, ğ, ı, İ, ö, ş, ü) and do NOT use English letters for Turkish characters.
Format your answer exactly like this:

[EN]: <paragraph>
[TR]: <translation>

Example:
[EN]: The sun was shining and the birds were singing in the park. People were walking their dogs and children were playing happily.
[TR]: Güneş parlıyordu ve kuşlar parkta ötüyordu. İnsanlar köpeklerini gezdiriyor ve çocuklar mutlu bir şekilde oynuyordu.

Now generate a new example:
''';

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://qwordazy.com',
          'X-Title': 'QwordazyApp',
        },
        body: jsonEncode({
          'model': 'mistralai/mistral-7b-instruct:free',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': 500,
          'temperature': 0.8,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        print('MODEL YANITI: $content'); // Debug için
        // Regex ile ayırma
        final enMatch = RegExp(r'\[EN\]:([\s\S]*?)(\[TR\]:|\Z)', caseSensitive: false).firstMatch(content);
        final trMatch = RegExp(r'\[TR\]:([\s\S]*)', caseSensitive: false).firstMatch(content);
        String paragraph = '';
        String translation = '';
        if (enMatch != null && trMatch != null) {
          paragraph = enMatch.group(1)?.trim() ?? '';
          translation = trMatch.group(1)?.trim() ?? '';
        } else {
          // Eğer format yoksa tüm yanıtı göster
          paragraph = content.trim();
          translation = content.trim();
        }
        return {
          'paragraph': paragraph,
          'translation': translation,
        };
      } else {
        print('API HATASI: ${response.body}');
        throw Exception('API Hatası: ${response.body}');
      }
    } catch (e) {
      print('API HATASI: $e');
      throw Exception('API Hatası: $e');
    }
  }
} 