import 'dart:io';
import 'package:logopedia/models/card_sample.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logopedia/providers/card_sample_provider.dart';
import 'package:provider/provider.dart';
import 'package:logopedia/providers/record_audio_provider.dart';
import 'package:logopedia/providers/play_audio_provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:logopedia/services/toast_services.dart';

class CreateSampleCardScreen extends StatefulWidget {
  const CreateSampleCardScreen({Key? key}) : super(key: key);

  @override
  State<CreateSampleCardScreen> createState() => _CreateSampleCardScreen();
}

class _CreateSampleCardScreen extends State<CreateSampleCardScreen> {
  final _picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();

  File selectedImage = File("");

  String currentAudioPath = "";
  String currentImagePath = "";
  String currentWord = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _recordProvider = Provider.of<RecordAudioProviders>(context);

    return Material(
      child: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          _displayRoundImageSection(),
          const SizedBox(height: 100),
          _wordInputSection(),
          _recordProvider.recordingOutputPath.isEmpty
              ? _recordingSection()
              : _audioPlayingSection(),
          const SizedBox(height: 50),
          // _showPreviewButton(),
          _submitCardButton(),
          _resetDataButton(),
          _goToMainPage(),
        ],
      )),
    );
  }

  _displayRoundImageSection() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 0, color: Colors.transparent),
        ),
        onPressed: () => _pickImage(),
        child: currentImagePath == ""
            ? const Text(
                'Dodaj zdjęcie',
                style: TextStyle(color: Colors.black),
              )
            : CircleAvatar(
                radius: 100.0,
                backgroundImage: FileImage(File(selectedImage.path)),
                backgroundColor: Colors.transparent,
              ));
  }

  _wordInputSection() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.90,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          cursorColor: Colors.black,
          controller: _textController,
          decoration: InputDecoration(
            labelText: 'Podaj słówko np. okno',
            labelStyle: const TextStyle(color: Colors.black),
            fillColor: Colors.red,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }

  _recordingSection() {
    final _recordProvider = Provider.of<RecordAudioProviders>(context);
    final _recordProviderWithoutListener =
        Provider.of<RecordAudioProviders>(context, listen: false);

    if (_recordProvider.isRecording) {
      return InkWell(
        customBorder: const CircleBorder(),
        onTap: () async {
          await _recordProviderWithoutListener.stopRecording();
        },
        child: RippleAnimation(
          repeat: true,
          color: const Color.fromARGB(255, 220, 220, 220),
          minRadius: 40,
          ripplesCount: 6,
          child: _commonIconSection(),
        ),
      );
    }

    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () async => await _recordProviderWithoutListener.recordVoice(),
      child: _commonIconSection(),
    );
  }

  _commonIconSection() {
    return Container(
      width: 70,
      height: 70,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: const Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(100)),
      child: const Icon(Icons.mic_none_outlined, size: 30, color: Colors.black),
    );
  }

  _audioPlayingSection() {
    final _recordProvider =
        Provider.of<RecordAudioProviders>(context, listen: false);

    return Container(
        width: MediaQuery.of(context).size.width - 110,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.black,
        ),
        child: Row(
          children: [
            _audioContollingSection(_recordProvider.recordingOutputPath),
            _audioProgressSection()
          ],
        ));
  }

  _audioContollingSection(String songPath) {
    final _playProvider = Provider.of<PlayAudioProvider>(context, listen: true);
    final _playProviderWithoutListeners =
        Provider.of<PlayAudioProvider>(context, listen: false);

    if (songPath.isNotEmpty) {
      currentAudioPath = songPath;
    }

    return IconButton(
        onPressed: () async {
          if (songPath.isEmpty) return;
          await _playProviderWithoutListeners.playAudio(File(songPath));
        },
        icon: Icon(
            _playProvider.isSongPlaying
                ? Icons.pause_outlined
                : Icons.play_arrow_outlined,
            color: Colors.white,
            size: 30));
  }

  _audioProgressSection() {
    final _playProvider = Provider.of<PlayAudioProvider>(context, listen: true);

    return Expanded(
      child: Container(
        width: double.maxFinite,
        height: 5,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        child: LinearPercentIndicator(
          percent: _playProvider.currLoadingStatus,
          backgroundColor: Colors.black,
          progressColor: Colors.white,
        ),
      ),
    );
  }

  _showPreviewButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, elevation: 1),
        child: const Text("Show card preview"),
        onPressed: () {
          if (_validateData()) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                actions: [_showCardPreview()],
                contentPadding: const EdgeInsets.all(20),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        currentImagePath = pickedFile.path;
      });
    }
  }

  _resetDataButton() {
    return TextButton(
      child: const Text(
        "Zresetuj dane",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () => _resetData(),
    );
  }

  _goToMainPage() {
    return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop('recordOwnSample'));
  }

  _showCardPreview() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.51,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          _displayRoundImageSection(),
          const SizedBox(height: 20),
          Text(
            _textController.text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 40),
          _audioPlayingSection(),
          const SizedBox(height: 35),
          _submitCardButton(),
        ]),
      ),
    );
  }

  _submitCardButton() {
    return OutlinedButton(
      onPressed: () => _submitCard(),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
      ),
      child: const Text(
        "Dodaj kartę",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  _submitCard() {
    if (_validateData()) {
      final _sampleCardProvider =
          Provider.of<CardSampleProvider>(context, listen: false);
      final _recordProvider =
          Provider.of<RecordAudioProviders>(context, listen: false);

      currentWord = _textController.text;
      currentImagePath = selectedImage.path;
      currentAudioPath = _recordProvider.recordingOutputPath;

      CardSample _cardSample = CardSample(
          word: currentWord,
          imagePath: currentImagePath,
          exampleAudioPath: currentAudioPath);

      _sampleCardProvider.addSampleCard(_cardSample);

      _resetData();

      // Navigator.pop(context);

      showToast("Karta dodana poprawnie");
    }
  }

  _resetData() {
    final _recordProvider =
        Provider.of<RecordAudioProviders>(context, listen: false);

    _recordProvider.clearOldData();
    _textController.clear();

    currentWord = "";
    currentAudioPath = "";
    currentImagePath = "";

    selectedImage = File("");

    showToast("Dane zresetowane");
  }

  _validateData() {
    final _recordProvider =
        Provider.of<RecordAudioProviders>(context, listen: false);

    if (_textController.text == "" ||
        _recordProvider.recordingOutputPath == "" ||
        currentImagePath == "") {
      showToast("Brakujące dane");
      return false;
    }
    return true;
  }
}
