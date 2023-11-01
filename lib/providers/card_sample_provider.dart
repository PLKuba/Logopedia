import 'package:flutter/material.dart';
import 'package:logopedia/models/card_sample.dart';

class CardSampleProvider extends ChangeNotifier {
  List<CardSample> additionalCards = [];

  CardSampleProvider();

  addSampleCard(CardSample card) {
    additionalCards.add(card);

    notifyListeners();
  }
}
