import 'package:flutter/material.dart';
import 'package:recipe_generator/API/APIKEY.dart';
import 'package:recipe_generator/globals.dart';

String _selectedLanguage = 'English';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _apiKeyController = TextEditingController(text: API_KEY);

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    // Save the API key and selected language and perform any necessary operations.
    String apiKey = _apiKeyController.text;
    API_KEY = apiKey;
    selectedLanguage = _selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'API Key',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _apiKeyController,
              decoration: InputDecoration(
                hintText: 'Enter your API key',
              ),
            ),
            DropdownButton<String>(
              borderRadius: BorderRadius.circular(12.0),
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              dropdownColor: Colors.white,
              items: <String>[
                'Svenska',
                'English',
                'Spanish',
                'French',
                'German',
                'Italian'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
