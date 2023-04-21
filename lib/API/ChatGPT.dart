import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_generator/API/APIKEY.dart';

Future<Object> getRecipe(String prompt) async {
  final String url =
      'https://api.openai.com/v1/chat/completions';
  final String model = 'gpt-3.5-turbo';
  final int maxTokens = 1024;
  final int temperature = 0;

  final Map<String, dynamic> data = {
    'model': model,
    'messages': [
      {
        'role': "assistant",
        'content':
            'You are a Chef who provides recipes based on ingredients, You only provide the recipe in swedish and metric'
      },
      {'role': "user", 'content': 'ingredients: '+ prompt + ' return only the JSON no other text. Format for response json format { "name": String, "description": String, "ingredients": [String], "directions": [String], "prep_time": String, "cook_time": String, "total_time": String, "servings": Int }'}
    ],
    'max_tokens': maxTokens,
    'temperature': temperature
  };

  final http.Response response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + API_KEY
    },
    body: jsonEncode(data),
  );

  final Map<String, dynamic> responseData = json.decode(response.body);
  final String output = responseData['choices'][0]['message']['content'];
  final Object recipe = jsonDecode(utf8.decode(output.runes.toList()));
  return recipe;
}
