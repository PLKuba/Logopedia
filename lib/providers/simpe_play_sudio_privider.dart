import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class SimpleAudioPlayer {
  String _audioFilePath = '';
  bool _isPlaying = false;
  bool _isLocal = false;
  List<AudioPlayer> audioPlayers = List.generate(
    1,
    (_) => AudioPlayer()..setReleaseMode(ReleaseMode.stop),
  );
  List<StreamSubscription> streams = [];

  bool get isPlaying => _isPlaying;
  bool get isLocal => _isLocal;

  SimpleAudioPlayer(String audioFilePath, {bool isLocal = false}) {
    _audioFilePath = audioFilePath;
    _isLocal = isLocal;
  }
}
