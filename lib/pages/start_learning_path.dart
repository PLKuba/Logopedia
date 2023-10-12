import 'package:flutter/material.dart';
import 'package:logopedia/providers/play_audio_provider.dart';
import 'package:logopedia/providers/record_audio_provider.dart';
import 'package:logopedia/providers/card_provider.dart';
import 'package:logopedia/screens/record_and_play_audio.dart';
import 'package:provider/provider.dart';

class StartLearning extends StatelessWidget {
  const StartLearning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return startLearning(context);
  }

  Widget startLearning(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => CardProvider()),
          ],
          builder: (context, child) {
            return buildCards(context);
          }
        ),
      ),
    );
  }

  Widget buildCards(BuildContext context) {
    final provider = Provider.of<CardProvider>(context);
    final position = provider.position;
    final words = provider.words;
    final paths = provider.paths;
    final imagePaths = provider.imagePaths;

    return Stack(
        children: words
            .map((word) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (_) => RecordAudioProviders()),
                    ChangeNotifierProvider(create: (_) => PlayAudioProvider()),
                    ChangeNotifierProvider(create: (_) => PlayExampleAudioProvider()),
                  ],
                  builder: (context, child) {
                    return RecordAndPlayScreen(
                      word: word,
                      path: paths[words.indexOf(word)],
                      imagePath: imagePaths[words.indexOf(word)],
                      isFront: words.last == word,
                    );
                  },
                ))
            .toList());
  }
}
