import 'package:flutter/material.dart';
import 'package:logopedia/models/swipe_summary.dart';

class GameDataProvider extends ChangeNotifier {
  final SwipeSummary swipeSummary;
  
  GameDataProvider({required this.swipeSummary});
}
