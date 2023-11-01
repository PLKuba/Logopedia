import 'package:flutter/material.dart';
import 'package:logopedia/pages/start_learning_path.dart';
import 'package:logopedia/pages/entry_page_path.dart';
import 'package:logopedia/pages/record_own_sample.dart';
import 'package:logopedia/providers/card_sample_provider.dart';
import 'package:provider/provider.dart';
import 'package:logopedia/models/card_sample.dart';

void main() {
  runApp(
    const Logopedia(),
  );
}

class Logopedia extends StatelessWidget {
  const Logopedia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( 
      create: (_) => CardSampleProvider(), 
      child: MaterialApp(
        title: 'Logopedia App', 
        initialRoute: '/', 
        routes: {
            '/': (context) => const EntryPage(),
            '/startLearning': (context) => StartLearning(entryRootContext: context),
            '/recordOwnSample': (context) => const RecordOwnSample(),
          },
        ),
      );
  }
}
