import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

class PlayAudioProvider extends ChangeNotifier {
  final _justAudioPlayer = AudioPlayer();
  double _currAudioPLaying = 0.0;
  bool _isSongPLaying = false;
  String _audioFilePath = '';

  bool get isSongPlaying => _isSongPLaying;
  String get currSongPath => _audioFilePath;

  setAudioFilePath(String incomingAudioFilePth) {
    _audioFilePath = incomingAudioFilePth;
    notifyListeners();
  }

  clearAudioFilePath() {
    _audioFilePath = '';
    notifyListeners();
  }

  playAudio(File incomingAudioFile, {bool update = true}) async {
    try {
      _justAudioPlayer.positionStream.listen((event) {
        _currAudioPLaying = event.inMicroseconds.ceilToDouble();
        if (update) notifyListeners();
      });

      _justAudioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          _justAudioPlayer.stop();
          _reset();
        }
      });

      if (_audioFilePath != incomingAudioFile.path) {
        setAudioFilePath(incomingAudioFile.path);

        await _justAudioPlayer.setFilePath(incomingAudioFile.path);
        updateSongPlayingStatus(true);
        await _justAudioPlayer.play();
      }

      if (_justAudioPlayer.processingState == ProcessingState.idle) {
        await _justAudioPlayer.setFilePath(incomingAudioFile.path);
        updateSongPlayingStatus(true);

        await _justAudioPlayer.play();
      } else if (_justAudioPlayer.playing) {
        updateSongPlayingStatus(false);

        await _justAudioPlayer.pause();
      } else if (_justAudioPlayer.processingState == ProcessingState.ready) {
        updateSongPlayingStatus(true);

        await _justAudioPlayer.play();
      } else if (_justAudioPlayer.processingState == ProcessingState.completed) {
        _reset();
      }
    } catch (e) {
      print('Error in playaudio: $e');
    }
  }

  _reset() {
    _currAudioPLaying = 0.00;
    notifyListeners();

    updateSongPlayingStatus(false);
  }

  updateSongPlayingStatus(bool status) {
    _isSongPLaying = status;
    notifyListeners();
  }

  get currLoadingStatus {
    final _currTime = (_currAudioPLaying /
        (_justAudioPlayer.duration?.inMicroseconds.ceilToDouble() ?? 1.0));

    return _currTime > 1.0 ? 1.0 : _currTime;
  }
}

class PlayExampleAudioProvider extends ChangeNotifier {
  final _justAudioPlayer = AudioPlayer();
  double _currAudioPLaying = 0.0;
  bool _isSongPLaying = false;
  String _audioFilePath = '';

  bool get isSongPlaying => _isSongPLaying;
  String get currSongPath => _audioFilePath;

  setAudioFilePath(String incomingAudioFilePth) {
    _audioFilePath = incomingAudioFilePth;
    notifyListeners();
  }

  clearAudioFilePath() {
    _audioFilePath = '';
    notifyListeners();
  }

  playAudio(File incomingAudioFile, {bool update = true}) async {
    try {
      _justAudioPlayer.positionStream.listen((event) {
        _currAudioPLaying = event.inMicroseconds.ceilToDouble();
        if (update) notifyListeners();
      });

      _justAudioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          _justAudioPlayer.stop();
          _reset();
        }
      });

      if (_audioFilePath != incomingAudioFile.path) {
        setAudioFilePath(incomingAudioFile.path);
        // print('incomingAudioFile.path: ${incomingAudioFile.path}');
        await _justAudioPlayer.setAsset(incomingAudioFile.path);
        updateSongPlayingStatus(true);
        await _justAudioPlayer.play();
      }

      if (_justAudioPlayer.processingState == ProcessingState.idle) {
        await _justAudioPlayer.setAsset(incomingAudioFile.path);
        updateSongPlayingStatus(true);

        await _justAudioPlayer.play();
      } else if (_justAudioPlayer.playing) {
        updateSongPlayingStatus(false);

        await _justAudioPlayer.pause();
      } else if (_justAudioPlayer.processingState == ProcessingState.ready) {
        updateSongPlayingStatus(true);

        await _justAudioPlayer.play();
      } else if (_justAudioPlayer.processingState ==
          ProcessingState.completed) {
        _reset();
      }
    } catch (e) {
      print('Error in playaudio: $e');
    }
  }

  _reset() {
    _currAudioPLaying = 0.00;
    notifyListeners();

    updateSongPlayingStatus(false);
  }

  updateSongPlayingStatus(bool status) {
    _isSongPLaying = status;
    notifyListeners();
  }

  get currLoadingStatus {
    final _currTime = (_currAudioPLaying /
        (_justAudioPlayer.duration?.inMicroseconds.ceilToDouble() ?? 1.0));

    return _currTime > 1.0 ? 1.0 : _currTime;
  }
}
