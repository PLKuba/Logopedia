import 'package:flutter/material.dart';
import 'package:logopedia/models/card_sample.dart';
import 'package:logopedia/providers/game_data_provider.dart';
import 'package:logopedia/providers/play_audio_provider.dart';
import 'package:logopedia/providers/record_audio_provider.dart';
import 'package:logopedia/providers/card_sample_provider.dart';
import 'package:logopedia/providers/card_provider.dart';
import 'package:logopedia/pages/record_and_play_audio.dart';
import 'package:logopedia/pages/game_summary_page.dart';
import 'package:provider/provider.dart';
import 'package:logopedia/models/swipe_summary.dart';

class StartLearning extends StatelessWidget {
  final BuildContext entryRootContext;
  final SwipeSummary swipeSummary = SwipeSummary();

  StartLearning({Key? key, required this.entryRootContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cardSampleProvider = Provider.of<CardSampleProvider>(context, listen: false);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GameDataProvider>(
            create: (_) => GameDataProvider(swipeSummary: swipeSummary)),
        ChangeNotifierProvider<CardProvider>(
            create: (_) => CardProvider(additionalCards: _cardSampleProvider.additionalCards)),
      ],
      builder: (context, child) {
        return MaterialApp(home: startLearning(context));
      },
    );
  }

  Widget startLearning(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: buildCards(context)),
    );
  }

  Widget buildCards(BuildContext context) {
    final provider = Provider.of<CardProvider>(context, listen: true);

    final words = provider.words;
    final paths = provider.paths;
    final imagePaths = provider.imagePaths;

    return words.isEmpty
        ? GameSummaryPage(
            swipeSummary: swipeSummary, entryRootContext: entryRootContext)
        : Stack(
            children: words
                .map((word) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                            create: (_) => RecordAudioProviders()),
                        ChangeNotifierProvider(
                            create: (_) => PlayAudioProvider()),
                        ChangeNotifierProvider(
                            create: (_) => PlayExampleAudioProvider()),
                        ChangeNotifierProvider(
                            create: (_) => PlayExampleAudioProvider()),
                      ],
                      builder: (context, child) {
                        return RecordAndPlayScreen(
                          word: word,
                          path: paths[words.indexOf(word)],
                          imagePath: imagePaths[words.indexOf(word)],
                          isFront: words.last == word,
                          gameDataProvider:
                              Provider.of<GameDataProvider>(context),
                        );
                      },
                    ))
                .toList());
  }
}
