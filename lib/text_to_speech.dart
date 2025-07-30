// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class TextToSpeechApp extends StatefulWidget {
  const TextToSpeechApp({super.key});

  @override
  _TextToSpeechAppState createState() => _TextToSpeechAppState();
}

class _TextToSpeechAppState extends State<TextToSpeechApp> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textController = TextEditingController();
  final translator = GoogleTranslator();

  String selectedLanguageCode = 'en-US';
  double speechRate = 0.5;
  bool useFemaleVoice = true;

  final Map<String, String> languageMap = {
    'English (US)': 'en-US',
    'Urdu': 'ur-PK',
    'Spanish': 'es-ES',
    'French': 'fr-FR',
    'German': 'de-DE',
    'Arabic': 'ar-SA',
    'Hindi': 'hi-IN',
  };

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> speak() async {
    String inputText = textController.text.trim();

    if (inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter some text")),
      );
      return;
    }

    // Check if language is supported
    List<dynamic> supportedLanguages = await flutterTts.getLanguages;
    if (!supportedLanguages.contains(selectedLanguageCode)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Selected language not supported on this device")),
      );
      return;
    }

    // Translate text
    Translation translation = await translator.translate(
      inputText,
      to: selectedLanguageCode.split('-')[0], // use only language code part
    );

    // Set voice (toggle male/female if available)
    List<dynamic> voices = await flutterTts.getVoices;
    var filteredVoices = voices.where((voice) =>
        voice['locale'] == selectedLanguageCode &&
        voice['name']
            .toLowerCase()
            .contains(useFemaleVoice ? 'female' : 'male'));

    if (filteredVoices.isNotEmpty) {
      await flutterTts.setVoice(filteredVoices.first);
    }

    useFemaleVoice = !useFemaleVoice;

    await flutterTts.setLanguage(selectedLanguageCode);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.speak(translation.text);
  }

  void stop() async {
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text to Speech Translator")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedLanguageCode,
              items: languageMap.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.value,
                  child: Text(entry.key),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => selectedLanguageCode = val);
                }
              },
              decoration: InputDecoration(labelText: "Select Language"),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: textController,
              decoration: InputDecoration(
                labelText: "Enter text",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text("Speed:"),
                Expanded(
                  child: Slider(
                    value: speechRate,
                    onChanged: (val) {
                      setState(() => speechRate = val);
                    },
                    min: 0.1,
                    max: 1.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: speak,
                  icon: Icon(Icons.play_arrow),
                  label: Text("Play"),
                ),
                SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: stop,
                  icon: Icon(Icons.stop),
                  label: Text("Stop"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
