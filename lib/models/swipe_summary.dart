import 'package:flutter/material.dart';

class SwipeSummary extends ChangeNotifier {
  int correctCount = 0;
  int midCount = 0;
  int incorrectCount = 0;

  SwipeSummary() {
    resetAllData();
  }

  void resetAllData() {
    correctCount = 0;
    midCount = 0;
    incorrectCount = 0;
    notifyListeners();
  }

  void addCorrectSwipe() {
    correctCount++;
  }

  void addMidSwipe() {
    midCount++;
  }

  void addIncorrectSwipe() {
    incorrectCount++;
  }
}
