import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIprompt {

  static String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  static const String baseUrl = 'https://api.openai.com/v1';

 static Future<String> getPGNfromImage(String base64image) async {
    try {
      print(base64image.length);
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
                    'text': '''Extract the chess moves from the score sheet in PGN format
                            Return the response with the following json format:
                            {
                              "date" : "MM/DD/YYYY or today's date if not visible",
                              "white": "White player's name",
                              "black": "black player's name",
                              "moves": "1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 4. Ba4 Nf6 5. O-O Be7 ...",
                              "loc" : "The place where the event happens or unknown if not visible.",
                              "event" : "Event name or unknown if not visible." ,
                              "win" : "'1/0' or '0/1' or '1/2 / 1/2' or unknown.",
                            }
                        ''' ,
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
          )).timeout(const Duration(seconds: 20));
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

