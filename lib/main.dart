import 'package:flutter/material.dart';
import 'package:logopedia/pages/start_learning_path.dart';
import 'package:logopedia/pages/entry_page_path.dart';
import 'package:logopedia/pages/record_own_sample.dart';
import 'package:logopedia/providers/card_sample_provider.dart';
import 'package:provider/provider.dart';
import 'package:logopedia/models/card_sample.dart';

void main() {
  runApp(
    const MaterialApp(
      home: EntryRoot(),
    ),
  );
}

class EntryRoot extends StatelessWidget {
  const EntryRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CardSampleProvider())
        ],
        builder: (context, child) {
          final _cardSampleProvider = Provider.of<CardSampleProvider>(context, listen: true);

          return MaterialApp(title: 'Logopedia App', home: const EntryPage(), routes: {
            '/startLearning': (context) => StartLearning(entryRootContext: context),
            '/entryPage': (context) => const EntryPage(),
            '/recordOwnSample': (context) => const RecordOwnSample(),
          });
        });
  }
}
