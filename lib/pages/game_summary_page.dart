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
          const Text('Game summary page'),
          Text('Correct Swipes: ${swipeSummary.correctCount}'),
          Text('Mid Swipes: ${swipeSummary.midCount}'),
          Text('Incorrect Swipes: ${swipeSummary.incorrectCount}'),
          ElevatedButton(
              onPressed: () {
                Navigator.of(entryRootContext).pushNamedAndRemoveUntil(
                    '/entryPage', (Route<dynamic> route) => false); // this will move me back to entry page
                    // add route to entry page
              },
              child: const Text('Go back to main page')),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false); // this will move me back to the start of the swiping game
                    // add route to entry page
              },
              child: const Text('Try again'))
        ],
      ),
    );
  }
}
