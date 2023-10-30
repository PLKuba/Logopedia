import 'dart:io';
import 'package:logopedia/models/card_sample.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logopedia/providers/card_provider.dart';
import 'package:logopedia/providers/play_audio_provider.dart';
import 'package:logopedia/providers/record_audio_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:logopedia/providers/card_sample_provider.dart';
import 'package:provider/provider.dart';
import 'package:logopedia/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class CreateSampleCardScreen extends StatefulWidget {
  const CreateSampleCardScreen({Key? key}) : super(key: key);

  @override
  State<CreateSampleCardScreen> createState() => _CreateSampleCardScreen();
}

class _CreateSampleCardScreen extends State<CreateSampleCardScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textController =
      TextEditingController(); // Create a TextEditingController
  File selectedImage = File("");
  String currentAudioPath = "";
  String currentImagePath = "";
  String currentWord = "";
  List<CardSample> newCards = [];
  List<Map<String, dynamic>> listOfDictionaries = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _recordProvider = Provider.of<RecordAudioProviders>(context);
    final _playProvider = Provider.of<PlayAudioProvider>(context);
    final _playExampleProvider = Provider.of<PlayExampleAudioProvider>(context);

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
          _showPreviewButton(),
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
            ? const Text('Upload photo')
            : const Text('Photo uploaded'));
  }

  // CircleAvatar(
  //               radius: 100.0,
  //               backgroundImage: FileImage(File(selectedImage.path)),
  //               backgroundColor: Colors.transparent,
  //             ));

  _wordInputSection() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.90,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _textController,
          decoration: const InputDecoration(labelText: 'Enter word e.g Ball'),
        ),
      ),
    );
  }

  _showPreviewButton() {
    return TextButton(
      child: const Text("Preview card"),
      onPressed: () => _showCardPreview(),
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
      child: const Text("Reset data"),
      onPressed: () => _resetData(),
    );
  }

  _goToMainPage() {
    return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EntryRoot(),
            )));
  }

  _resetData() {
    _textController.clear();

    currentWord = "";
    currentAudioPath = "";

    Image.memory(File(currentImagePath).readAsBytesSync());
    currentImagePath = "";

    selectedImage = File("");

    print([1, selectedImage.path, currentImagePath]);
  }

  _showCardPreview() {}

  _submitCardButton(){
    return TextButton(
      child: const Text("Submit card"),
      onPressed: () => _submitCard(),
    );
  }

  _submitCard() {
    final _sampleCardProvider = Provider.of<CardSampleProvider>(context, listen: false);
    String word = "tesWord";
    String imagePath = "assets/exampleImages/pilka.jpeg";
    String exampleAudioPath = "assets/exampleAudios/pilka.mp3";

    CardSample _cardSample = CardSample(word: word, imagePath: imagePath, exampleAudioPath: exampleAudioPath);

    _sampleCardProvider.addSampleCard(_cardSample);
  }

  // Future _selectImageWidget(BuildContext context) async {
  //   var image = await _picker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     selectedImage = File(image!.path); // won't have any error now
  //     currentImagePath = selectedImage.path;

  //     CardSample cardSample = CardSample(
  //         word: 'test1234',
  //         imagePath: selectedImage.path,
  //         exampleAudioPath: 'assets/exampleAudios/ksiega.mp3');

  //     final _cardSampleProvider =
  //         Provider.of<CardSampleProvider>(context, listen: false);
  //     _cardSampleProvider.addSampleCard(cardSample);
  //     print(_cardSampleProvider.additionalCards[0].exampleAudioPath);
  //   });
  // }

  // _addSampleToCards() {
  //   // CardSample _tempCard = CardSample(
  //   //     word: word, imagePath: imagePath, exampleAudioPath: audioPath);

  //   // newCards.add(_tempCard);

  //   _showToast("Card added succesfully");
  // }

  // _showToast(String content) {
  //   Fluttertoast.showToast(
  //     msg: content,
  //   );
  // }

  // _resetButton() {
  //   final _recordProvider = Provider.of<RecordAudioProviders>(context, listen: false);

  //   return InkWell(
  //     onTap: () => _recordProvider.clearOldData(),
  //     child: Center(
  //       child: Container(
  //         width: MediaQuery.of(context).size.width - 110,
  //         height: 50,
  //         padding: const EdgeInsets.symmetric(horizontal: 10),
  //         margin: const EdgeInsets.only(bottom: 10),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(100),
  //           color: Colors.black,
  //         ),
  //         child: const Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(Icons.refresh_outlined, color: Colors.white, size: 30),
  //             SizedBox(width: 10),
  //             Text(
  //               'Reset',
  //               style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // _playAudioHeading() {
  //   return const Center(
  //     child: Text(
  //       'Your version',
  //       style: TextStyle(
  //           fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
  //     ),
  //   );
  // }

  // _recordingSection() {
  //   final _recordProvider = Provider.of<RecordAudioProviders>(context);
  //   final _recordProviderWithoutListener =
  //       Provider.of<RecordAudioProviders>(context, listen: false);

  //   if (_recordProvider.isRecording) {
  //     return InkWell(
  //       customBorder: const CircleBorder(),
  //       onTap: () async {
  //         await _recordProviderWithoutListener.stopRecording();
  //       },
  //       child: RippleAnimation(
  //         repeat: true,
  //         color: const Color.fromARGB(255, 220, 220, 220),
  //         minRadius: 40,
  //         ripplesCount: 6,
  //         child: _commonIconSection(),
  //       ),
  //     );
  //   }

  //   return InkWell(
  //     customBorder: const CircleBorder(),
  //     onTap: () async => await _recordProviderWithoutListener.recordVoice(),
  //     child: _commonIconSection(),
  //   );
  // }

  // _commonIconSection() {
  //   return Container(
  //     width: 70,
  //     height: 70,
  //     padding: const EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //         color: const Color(0xffF5F5F5),
  //         borderRadius: BorderRadius.circular(100)),
  //     child: const Icon(Icons.mic_none_outlined, size: 30, color: Colors.black),
  //   );
  // }
}
