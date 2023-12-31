import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logopedia/models/card_sample.dart';
import 'package:logopedia/providers/game_data_provider.dart';

enum WordStatus { poprawne, niepoprawne, niezbyt }

class CardProvider extends ChangeNotifier {
  List<String> _words = [];
  List<String> _paths = [];
  List<String> _imagePaths = [];
  Offset _position = Offset.zero;
  double _angle = 0;
  bool _isDragging = false;
  Size _screenSize = Size.zero;
  List<CardSample>? additionalCards = [];

  List<String> get words => _words;
  List<String> get paths => _paths;
  List<String> get imagePaths => _imagePaths;
  Offset get position => _position;
  bool get isDragging => _isDragging;
  double get angle => _angle;

  CardProvider({this.additionalCards}) {
    resetWords();
  }

  void setScreenSize(Size screenSize) {
    _screenSize = screenSize;
  }

  void startPosition(DragStartDetails details) {
    _isDragging = true;
    notifyListeners();

    // print('Start Position ${details.globalPosition}');
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 10 * x / _screenSize.width;

    notifyListeners();

    // print('Update Position ${details.globalPosition}');
  }

  void endPosition(DragEndDetails details, GameDataProvider gameDataProvider) {
    _isDragging = false;

    final status = getStatus();

    if (status != null) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: status.toString().split('.').last.toUpperCase(),
      );
    }

    switch (status) {
      case WordStatus.poprawne:
        correctSwipe();
        gameDataProvider.swipeSummary.addCorrectSwipe();
        break;
      case WordStatus.niepoprawne:
        incorrectSwipe();
        gameDataProvider.swipeSummary.addIncorrectSwipe();
        break;
      case WordStatus.niezbyt:
        midSwipe();
        gameDataProvider.swipeSummary.addMidSwipe();
        break;
      default:
        resetPosition();
    }

    // resetPosition();

    // print('End Position velocity ${details.velocity}');
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  WordStatus? getStatus() {
    final x = _position.dx;
    final y = _position.dy;
    final forceMid = x.abs() < 20;
    const delta = 130;

    // print('x: $x, delta: $delta');
    if (x >= delta) {
      return WordStatus.poprawne;
    } else if (x <= -delta) {
      return WordStatus.niepoprawne;
    } else if (y <= -delta / 2 && forceMid) {
      return WordStatus.niezbyt;
    } else {
      return null;
    }
  }

  // iPhone 14 Pro _screenSize: Size(393.0, 852.0)
  void correctSwipe() {
    _angle = 20;
    // print(_position);
    _position += Offset(_screenSize.width, 0);
    // print(_position);/
    _nextCard();

    // swipeSummary.addCorrectSwipe();

    notifyListeners();
  }

  void incorrectSwipe() {
    _angle = -20;
    _position -= Offset(_screenSize.width, 0);
    _nextCard();

    // swipeSummary.addIncorrectSwipe();

    notifyListeners();
  }

  void midSwipe() {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    _nextCard();

    // swipeSummary.addMidSwipe();

    notifyListeners();
  }

  Future _nextCard() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _words.removeLast();
    _paths.removeLast();
    _imagePaths.removeLast();
    resetPosition();
  }

  void addCards(List<CardSample>? addiitonalCards) {
    if(addiitonalCards != null){
      for (CardSample cardSample in addiitonalCards) {
        _words.add(cardSample.word);
        _imagePaths.add(cardSample.imagePath);
        _paths.add(cardSample.exampleAudioPath);
      }
    }
  }

  void resetWords() {
    _words = <String>[
      'Szabla',
      'Szafa',
      'Szalik',
      'Szampon',
      'Szopa',
      'Szuflada',
      'Szuka',
      'Szumi',
      'Szyba',
      'Szykuje'
    ];

    _paths = <String>[
      'assets/exampleAudios/szabla.mp3',
      'assets/exampleAudios/szafa.mp3',
      'assets/exampleAudios/szalik.mp3',
      'assets/exampleAudios/szampon.mp3',
      'assets/exampleAudios/szopa.mp3',
      'assets/exampleAudios/szuflada.mp3',
      'assets/exampleAudios/szuka.mp3',
      'assets/exampleAudios/szumi.mp3',
      'assets/exampleAudios/szyba.mp3',
      'assets/exampleAudios/szykuje.mp3'
    ];

    _imagePaths = <String>[
      'assets/exampleImages/szabla.jpeg',
      'assets/exampleImages/szafa.jpeg',
      'assets/exampleImages/szalik.jpeg',
      'assets/exampleImages/szampon.jpeg',
      'assets/exampleImages/szopa.jpeg',
      'assets/exampleImages/szuflada.jpeg',
      'assets/exampleImages/szuka.jpeg',
      'assets/exampleImages/szumi.jpeg',
      'assets/exampleImages/szyba.jpeg',
      'assets/exampleImages/szykuje.jpeg'
    ];

    addCards(additionalCards);

    _words = _words.reversed.toList();
    _paths = _paths.reversed.toList();
    _imagePaths = _imagePaths.reversed.toList();

    notifyListeners();
  }
}
