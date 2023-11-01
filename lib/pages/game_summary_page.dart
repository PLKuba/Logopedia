import 'package:flutter/material.dart';
import 'package:logopedia/models/swipe_summary.dart';

class GameSummaryPage extends StatelessWidget {
  final SwipeSummary swipeSummary;
  final BuildContext entryRootContext;

  const GameSummaryPage({Key? key, required this.swipeSummary, required this.entryRootContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Podsumowanie'),
          Text('Poprawnych słówek: ${swipeSummary.correctCount}'),
          Text('Średnio poprawne: ${swipeSummary.midCount}'),
          Text('Niepoprawne słówka: ${swipeSummary.incorrectCount}'),
          ElevatedButton(
              onPressed: () {
                Navigator.of(entryRootContext).pushNamed('/');
              },
              child: const Text('Powrót do menu głównego')),
          ElevatedButton(
              onPressed: () {
                Navigator.of(entryRootContext).pushNamed('/startLearning');
              },
              child: const Text('Spróbuj ponownie'))
        ],
      ),
    );
  }
}
