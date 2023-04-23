import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_generator/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe_generator/Recipe.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

Future<Recipe> getRecipe(String prompt) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? api_key = prefs.getString('api_key');
  double gpt_max_token = prefs.getDouble('gpt_max_token')??1024;
  final String url =
      'https://api.openai.com/v1/chat/completions';
  final String model = 'gpt-3.5-turbo';
  final int temperature = 0;

  if(prompt.isEmpty){
    throw ApiException("Du måste välja ingredienser först");
  }
  if(api_key == null){
    throw ApiException("Du har inte fyllt i en API nyckel");
  }

  final Map<String, dynamic> data = {
    'model': model,
    'messages': [
      {
        'role': "assistant",
        'content':
            'You are a Chef who provides recipes based on ingredients, You only provide the recipe in '+selectedLanguage+' and metric'
      },
      {'role': "user", 'content': 'ingredients: '+ prompt + ' return only the JSON no other text in '+selectedLanguage+'. Format for response json format { "name": String, "description": String, "ingredients": [String], "directions": [String not numbered], "prep_time": String, "cook_time": String, "total_time": String, "servings": Int, "image_query_text": three image search query words for the dish }'}
    ],
    'max_tokens': gpt_max_token.toInt(),
    'temperature': temperature
  };

  final http.Response response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + api_key
    },
    body: jsonEncode(data),
  );

  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}");

  if (response.statusCode != 200) {
    final Map<String, dynamic> errorData = json.decode(response.body);
    throw ApiException(errorData['error']['message']);
  }
  
  try{
    final Map<String, dynamic> responseData = json.decode(response.body);
    final String output = responseData['choices'][0]['message']['content'];
    final Recipe recipe = Recipe.fromJson(jsonDecode(utf8.decode(output.runes.toList())));
    return recipe;
  }catch(e){
    throw Exception(e);
  }
}
