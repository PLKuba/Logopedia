import 'package:flutter/material.dart';
import 'package:logopedia/services/permission_management.dart';
import 'package:logopedia/services/storage_management.dart';
import 'package:logopedia/services/toast_services.dart';
import 'package:record/record.dart';

class RecordAudioProviders extends ChangeNotifier {
  final Record _record = Record();

  bool _isrecording = false;
  String _recordingOutputPath = '';

  bool get isRecording => _isrecording;
  String get recordingOutputPath => _recordingOutputPath;

  clearOldData() {
    _recordingOutputPath = '';
    notifyListeners();
  }

  recordVoice() async {
    final _isPermitted = (await PermissionManagement.recordingPermission()) &&
        (await PermissionManagement.storagePermission());

    if (!_isPermitted) return;

    if (!(await _record.hasPermission())) return;

    final _voiceDirPath = await StorageManagement.getAudioDir;
    final _voiceFilePath = StorageManagement.createRecordAudioPath(
        dirPath: _voiceDirPath, fileName: 'audio_message');

    await _record.start(path: _voiceFilePath);

    _isrecording = true;
    notifyListeners();

    showToast('Nagrywanie rozpoczęte');
  }

  stopRecording() async {
    String? _audioFilePath;

    if (await _record.isRecording()) {
      _audioFilePath = await _record.stop();
      showToast('Nagrywanie zakończone');
    }

    _isrecording = false;
    _recordingOutputPath = _audioFilePath ?? '';
    notifyListeners();
  }
}
