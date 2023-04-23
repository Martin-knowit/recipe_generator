import 'package:flutter/material.dart';
import 'package:recipe_generator/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

String _selectedLanguage = 'Swedish';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _apiKeyController = TextEditingController(text: "API_KEY");
  double _gptMaxToken = 1024;
  List<double> _sliderValues = [256, 512, 1024, 2048, 4096];
  
  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myValue = prefs.getString('api_key');

    if (myValue != null) {
      setState(() {
        _apiKeyController.text = myValue;
      });
    }
    double? gptMaxToken = prefs.getDouble('gpt_max_token');
    if (gptMaxToken != null) {
      setState(() {
        _gptMaxToken = gptMaxToken;
      });
    }
  }

  void _saveSettings() async {
    // Save the API key and selected language and perform any necessary operations.
    String apiKey = _apiKeyController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('api_key', apiKey);
    prefs.setDouble('gpt_max_token', _gptMaxToken);
    selectedLanguage = _selectedLanguage;
  }

@override
Widget build(BuildContext context) {
  return FutureBuilder(
    future: SharedPreferences.getInstance(),
    builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
      if (!snapshot.hasData) {
        return CircularProgressIndicator();
      }

      SharedPreferences prefs = snapshot.data!;
      String apiKey = prefs.getString('api_key') ?? '';

      _apiKeyController.text = apiKey;

      return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                SizedBox(height: 16),
                Text(
                  'ChatGPT maxToken',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbColor: Colors.blue,
                    activeTrackColor: Colors.blue,
                    inactiveTrackColor: Colors.grey,
                    overlayColor: Colors.blue.withAlpha(32),
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
                  ),
                  child: Slider(
                    value: _gptMaxToken,
                    min: _sliderValues.first,
                    max: _sliderValues.last,
                    semanticFormatterCallback: (double value) => _sliderValues.contains(value)
                        ? value.round().toString()
                        : "",
                    divisions: _sliderValues.length - 1,
                    label: _gptMaxToken.round().toString(),
                    onChanged: (newValue) {
                      setState(() {
                        _gptMaxToken = newValue;
                      });
                    },
                  ),
                ),
                if (_gptMaxToken <= 512)
                  Text(
                    'Varning: För lågt värde kan leda till att förfrågan misslyckas.',
                    style: TextStyle(color: Colors.red),
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
                    'Swedish',
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
                  child: Text('Spara inställningar'),
                ),
                SizedBox(height: 16),
                OnboardingInformationView(),
              ],
            ),
          ),
        ),
      );
    },
  );
}
}


Widget OnboardingInformationView() {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Välkommen till Recipe Generator!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'För att använda appen behöver du ha en API-nyckel från OpenAI. Följ dessa steg för att komma igång:',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
        RichText(
          text: TextSpan(
            text: '1. Besök ',
            style: TextStyle(fontSize: 16, color: Colors.black),
            children: [
              TextSpan(
                text: 'OpenAI:s hemsida',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launch('https://openai.com/product'),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          '2. Lägg till en betalningsmetod. Det är mycket billigt att använda. 100 recept kostar ca 4 SEK.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          '3. Kopiera din API-nyckel.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          '4. Klistra in din API-nyckel i rutan ovanför.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}

