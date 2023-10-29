import 'package:flutter/material.dart';
import 'package:logopedia/models/card_sample.dart';
import 'package:logopedia/pages/start_learning_path.dart';
import 'package:logopedia/pages/entry_page_path.dart';
import 'package:logopedia/pages/record_own_sample.dart';

void main() {
  runApp(
    const MaterialApp(
      home: EntryRoot(additionalCards: []),
    ),
  );
}

class EntryRoot extends StatelessWidget {
  const EntryRoot({Key? key, required this.additionalCards}) : super(key: key);

  final List<CardSample> additionalCards;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Logopedia App',
        home: const EntryPage(),
        routes: {
          '/startLearning': (context) => StartLearning(entryRootContext: context, additionalCards: additionalCards),
          '/entryPage': (context) => const EntryPage(),
          // '/recordOwnSample': (context) => const RecordOwnSample(),
        });
  }
}
