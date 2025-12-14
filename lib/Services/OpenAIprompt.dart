import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIprompt {

  static String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  static const String baseUrl = 'https://api.openai.com/v1';

 static Future<String> getPGNfromImage(String base64image) async {
    try {
      print(base64image);
      final response = await http.post(
          Uri.parse('$baseUrl/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            'model': 'gpt-4o',
            'messages': [
              {
                'role': 'user',
                'content': [
                  {
                    'type': 'text',
                    'text': "Extract the chess moves from the score sheet in PGN format.",
                  },
                  {
                    'type' : 'image_url',
                    'image_url' : {
                      'url' : 'data:image/jpeg;base64,$base64image'
                    }
                  }
                ]}
            ],
            'max_tokens': 2000,
          },
          ));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final analysisText = data['choices'][0]['message']['content'];
        return analysisText;
      } else {
        throw Exception('Failed to analyze game: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error analyzing game: $e');
    }
  }
  static Future<String> test() async {
    try {
      print("testing");
      final response = await http.post(
          Uri.parse('$baseUrl/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            'model': 'gpt-4o',
            'messages': [
              {
                'role': 'user',
                'content': [
                  {
                    'type': 'text',
                    'text': "hello",
                  },
                ]}
            ],
            'max_tokens': 2000,
          },
          ));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final analysisText = data['choices'][0]['message']['content'];
        return analysisText;
      } else {
        throw Exception('Failed to analyze game: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error analyzing game: $e');
    }
  }
}

