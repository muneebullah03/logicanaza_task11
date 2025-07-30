// ignore_for_file: unused_local_variable

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class TextToSpeech extends StatefulWidget {
  const TextToSpeech({super.key});

  @override
  State<TextToSpeech> createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
  TextEditingController textController = TextEditingController();
  FlutterTts flutterTts = FlutterTts();
  double speechRange = 0.5;
  bool isSpeaking = false;

  play() async {
    if (textController.text.trim().isEmpty) return;

    var translation = await translator.translate(
      textController.text,
      to: selectedLanguageCode,
    );

    await flutterTts.setLanguage(selectedLanguageCode);
    await flutterTts.setSpeechRate(speechRange);

    await flutterTts.speak(translation.text);
  }

  pause() async {
    await flutterTts.pause();
    isSpeaking = false;
    setState(() {});
  }

  stop() async {
    await flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  speech(val) {
    speechRange = val;

    flutterTts.setSpeechRate(speechRange);
  }

  @override
  void initState() {
    super.initState();
    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  final translator = GoogleTranslator();
  String selectedLanguageCode = 'en';
  Map<String, String> languageMap = {
    'English': 'en',
    'Chinese': 'zh-CN',
    'Urdu': 'ur',
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Arabic': 'ar',
    'Russian': 'ru',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            SizedBox(height: 53),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 31),
              child: DropdownButtonFormField<String>(
                  value: selectedLanguageCode,
                  decoration: InputDecoration(
                    labelText: "Select Language",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  items: languageMap.entries
                      .map((entery) => DropdownMenuItem(
                          value: entery.value, child: Text(entery.key)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLanguageCode = value!;
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 24),
              child: Container(
                padding: EdgeInsets.all(8),
                height: 256,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(239, 244, 247, 247),
                    border:
                        Border.all(strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  controller: textController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 33),
            AvatarGlow(
              glowColor: Colors.indigoAccent,
              animate: isSpeaking,
              curve: Curves.fastOutSlowIn,
              child: const Material(
                elevation: 8.0,
                shape: CircleBorder(),
                color: Colors.transparent,
                child: CircleAvatar(
                  radius: 50.0,
                  child: Icon(Icons.mic_none_outlined),
                ),
              ),
            ),
            SizedBox(height: 53),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  color: Colors.green,
                  splashRadius: 41,
                  iconSize: 61,
                  onPressed: play,
                  icon: Icon(Icons.play_circle),
                ),
                IconButton(
                  color: Colors.red,
                  splashRadius: 41,
                  iconSize: 61,
                  onPressed: stop,
                  icon: Icon(Icons.stop_circle),
                ),
                IconButton(
                  color: Colors.yellow,
                  splashRadius: 41,
                  iconSize: 61,
                  onPressed: pause,
                  icon: Icon(Icons.pause_circle),
                )
              ],
            ),
            SizedBox(height: 12),
            Text("Set speed"),
            SizedBox(height: 12),
            Slider(
                max: 1,
                value: speechRange,
                divisions: 10,
                label: "Set speech rate ",
                onChanged: (value) {
                  speech(value);
                  setState(() {});
                })
          ],
        )),
      ),
    );
  }
}
