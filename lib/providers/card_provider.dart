import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logopedia/providers/game_data_provider.dart';

enum WordStatus { correct, incorrect, mid }

class CardProvider extends ChangeNotifier {
  List<String> _words = [];
  List<String> _paths = [];
  List<String> _imagePaths = [];
  Offset _position = Offset.zero;
  double _angle = 0;
  bool _isDragging = false;
  Size _screenSize = Size.zero;


  List<String> get words => _words;
  List<String> get paths => _paths;
  List<String> get imagePaths => _imagePaths;
  Offset get position => _position;
  bool get isDragging => _isDragging;
  double get angle => _angle;

  CardProvider() {
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
      case WordStatus.correct:
        correctSwipe();
        gameDataProvider.swipeSummary.addCorrectSwipe();
        break;
      case WordStatus.incorrect:
        incorrectSwipe();
        gameDataProvider.swipeSummary.addIncorrectSwipe();
        break;
      case WordStatus.mid:
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
    const delta = 200;

    // print('x: $x, delta: $delta');
    if (x >= delta) {
      return WordStatus.correct;
    } else if (x <= -delta) {
      return WordStatus.incorrect;
    } else if (y <= -delta / 2 && forceMid) {
      return WordStatus.mid;
    }else{
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

  void resetWords() {
    _words = <String>[
      'Piłka',
      'Czapka',
      'Czepek',
      'Książka',
      'Ksiądz',
      'Księżniczka',
      'Księga'
    ].reversed.toList();

    _paths = <String>[
      'assets/exampleAudios/pilka.mp3',
      'assets/exampleAudios/czapka.mp3',
      'assets/exampleAudios/czepek.mp3',
      'assets/exampleAudios/ksiazka.mp3',
      'assets/exampleAudios/ksiadz.mp3',
      'assets/exampleAudios/ksiezniczka.mp3',
      'assets/exampleAudios/ksiega.mp3'
    ].reversed.toList();

    _imagePaths = <String>[
      'assets/exampleImages/pilka.jpeg',
      'assets/exampleImages/czapka.jpeg',
      'assets/exampleImages/czepek.jpeg',
      'assets/exampleImages/ksiazka.jpeg',
      'assets/exampleImages/ksiadz.jpeg',
      'assets/exampleImages/ksiezniczka.jpeg',
      'assets/exampleImages/ksiega.jpeg'
    ].reversed.toList();

    notifyListeners();
  }
}
