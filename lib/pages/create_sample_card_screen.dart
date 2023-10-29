import 'dart:io';
import 'package:logopedia/models/card_sample.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logopedia/providers/card_provider.dart';
import 'package:provider/provider.dart';
import 'package:logopedia/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateSampleCardScreen extends StatefulWidget {
  const CreateSampleCardScreen({Key? key}) : super(key: key);

  @override
  State<CreateSampleCardScreen> createState() => _CreateSampleCardScreen();
}

class _CreateSampleCardScreen extends State<CreateSampleCardScreen> {
  final ImagePicker _picker = ImagePicker();
  File selectedImage = File("");
  String audioPath = "";
  String imagePath = "";
  String word = "";
  List<CardSample> newCards = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
          child: Column(
        children: [
          const Text('siemaSZ'),
          _displayRoundImageSection(),
          _addButton(),
          _resetButton(),
          _goToMainPage(),
        ],
      )),
    );
  }

  _displayRoundImageSection() {
    return Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: imagePath != ""
            ? Image.asset(imagePath, height: 200, width: 200)
            : IconButton(
                icon: const Icon(Icons.microwave),
                onPressed: () => _selectImageWidget(context),
              ));
  }

  Future _selectImageWidget(BuildContext context) async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      final _cardProvider = Provider.of<CardProvider>(context, listen: false);
      selectedImage = File(image!.path); // won't have any error now

      audioPath = "assets/exampleAudios/pilka.mp3";
      imagePath = selectedImage.path;
      word = "dupa";
    });
  }

  _goToMainPage() {
    return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntryRoot(additionalCards: newCards),
            )));
  }

  _resetButton() {
    return TextButton(
      child: const Text("Start over"),
      onPressed: () => _resetData(),
    );
  }

  _addButton() {
    return TextButton(
      child: const Text("Add this word"),
      onPressed: () => _addSampleToCards(),
    );
  }

  _addSampleToCards() {
    CardSample _tempCard = CardSample(
        word: word, imagePath: imagePath, exampleAudioPath: audioPath);

    newCards.add(_tempCard);

    _showToast("Card added succesfully");
  }

  _showToast(String content) {
    Fluttertoast.showToast(
      msg: content,
    );
  }

  _resetData() {
    word = "";
    audioPath = "";
    imagePath = "";
  }
}
