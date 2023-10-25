import 'package:flutter/material.dart';
import 'package:logopedia/pages/start_learning_path.dart';
import 'package:logopedia/pages/entry_page_path.dart';

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
    return MaterialApp(
        title: 'Logopedia App',
        home: const EntryPage(),
        routes: {
          '/startLearning': (context) => StartLearning(entryRootContext: context,),
          '/entryPage': (context) => const EntryPage(),
        });
  }
}
