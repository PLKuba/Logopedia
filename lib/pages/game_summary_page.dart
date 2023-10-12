import 'package:flutter/material.dart';

class GameSummaryPage extends StatelessWidget {
  const GameSummaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return gameSummaryPage(context);
  }

  Widget gameSummaryPage(BuildContext context) {
    return const Scaffold(
      body: Text('Game Summary Page'),
    );
  }
}
