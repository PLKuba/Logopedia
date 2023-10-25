import 'package:flutter/material.dart';

class SwipeSummary extends ChangeNotifier{
  int correctCount = 0;
  int midCount = 0;
  int incorrectCount = 0;

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