import 'package:flutter/material.dart';
import 'package:logopedia/models/card_sample.dart';

class CardSampleProvider extends ChangeNotifier {
  List<CardSample> additionalCards = [
    CardSample(
        word: "123",
        imagePath: "assets/exampleImages/ksiega.jpeg",
        exampleAudioPath: "assets/exampleAudios/ksiega.mp3")
  ];

  CardSampleProvider();

  addSampleCard(CardSample card) {
    additionalCards.add(card);

    notifyListeners();
  }
}
