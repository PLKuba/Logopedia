import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logopedia/providers/game_data_provider.dart';
import 'package:logopedia/providers/play_audio_provider.dart';
import 'package:logopedia/providers/record_audio_provider.dart';
import 'package:logopedia/providers/card_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class RecordAndPlayScreen extends StatefulWidget {
  final String word;
  final String path;
  final String imagePath;
  final bool isFront;
  final GameDataProvider gameDataProvider;

  const RecordAndPlayScreen(
      {Key? key,
      required this.word,
      required this.path,
      required this.imagePath,
      required this.isFront,
      required this.gameDataProvider})
      : super(key: key);

  @override
  State<RecordAndPlayScreen> createState() => _RecordAndPlayScreenState();
}

class _RecordAndPlayScreenState extends State<RecordAndPlayScreen> {
  customizeStatusAndNavigationBar() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
  }

  @override
  void initState() {
    super.initState();

    customizeStatusAndNavigationBar();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isFront ? buildFrontCard(context) : buildCard(context);
  }

  Widget buildFrontCard(BuildContext context) => GestureDetector(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final provider = Provider.of<CardProvider>(context);
            final position = provider.position;
            final miliseconds = provider.isDragging ? 0 : 400;

            final center = constraints.smallest.center(Offset.zero);

            final angle = provider.angle * 3.1415926535897932 / 180;
            final rotatedMatrix = Matrix4.identity()
              ..translate(center.dx, center.dy)
              ..rotateZ(angle)
              ..translate(-center.dx, -center.dy);

            return AnimatedContainer(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: miliseconds),
                transform: rotatedMatrix..translate(position.dx, position.dy),
                child: buildCard(context));
          },
        ),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.endPosition(details, widget.gameDataProvider);
        },
      );

  Widget buildCard(BuildContext context) {
    final _recordProvider = Provider.of<RecordAudioProviders>(context);
    final _playProvider = Provider.of<PlayAudioProvider>(context);
    final _playExampleProvider = Provider.of<PlayExampleAudioProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: DecoratedBox(
          decoration: const BoxDecoration(
              // border: Border.all(
              //   color: Colors.red,
              //   width: 2,
              // ),
              ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _displayImageSection(),
              if (_recordProvider.recordingOutputPath.isNotEmpty)
                _playExampleHeading(),
              const SizedBox(height: 50),
              if (_recordProvider.recordingOutputPath.isNotEmpty)
                _exampleAudioPlayingSection(),
              const SizedBox(height: 20),
              _recordProvider.recordingOutputPath.isEmpty
                  ? _recordHeading()
                  : _playAudioHeading(),
              const SizedBox(height: 50),
              _recordProvider.recordingOutputPath.isEmpty
                  ? _recordingSection()
                  : _audioPlayingSection(),
              if (_recordProvider.recordingOutputPath.isNotEmpty &&
                  !_playProvider.isSongPlaying)
                const SizedBox(height: 50),
              if (_recordProvider.recordingOutputPath.isNotEmpty &&
                  !_playProvider.isSongPlaying &&
                  !_playExampleProvider.isSongPlaying)
                _resetButton()
            ],
          ),
        ),
      ),
    );
  }

  _displayImageSection() {
    return Image.asset(widget.imagePath, height: 200, width: 200);
  }

  _playExampleHeading() {
    return const Center(
      child: Text(
        'Ideal pronunciation',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  _exampleAudioPlayingSection() {
    final _recordProvider = Provider.of<RecordAudioProviders>(context);

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
            _exampleAudioContollingSection(_recordProvider.recordingOutputPath),
            _exampleAudioProgressSection()
          ],
        ));
  }

  _recordHeading() {
    return Center(
      child: Text(
        widget.word,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  _playAudioHeading() {
    return const Center(
      child: Text(
        'Your version',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
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
        onTap: () async => await _recordProviderWithoutListener.stopRecording(),
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
        child: const Icon(Icons.mic_none_outlined,
        size: 30, color: Colors.black),
    );
  }

  _audioPlayingSection() {
    final _recordProvider = Provider.of<RecordAudioProviders>(context);

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

  _exampleAudioContollingSection(String songPath) {
    final _playProvider = Provider.of<PlayExampleAudioProvider>(context);
    final _playProviderWithoutListeners =
        Provider.of<PlayExampleAudioProvider>(context, listen: false);
    // print(widget.path);
    return IconButton(
        onPressed: () async {
          if (songPath.isEmpty) return;
          await _playProviderWithoutListeners.playAudio(File(widget.path));
        },
        icon: Icon(
            _playProvider.isSongPlaying
                ? Icons.pause_outlined
                : Icons.play_arrow_outlined,
            color: Colors.white,
            size: 30));
  }

  _audioContollingSection(String songPath) {
    final _playProvider = Provider.of<PlayAudioProvider>(context);
    final _playProviderWithoutListeners =
        Provider.of<PlayAudioProvider>(context, listen: false);

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
    final _playProvider = Provider.of<PlayAudioProvider>(context);

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

  _exampleAudioProgressSection() {
    final _playProvider = Provider.of<PlayExampleAudioProvider>(context);

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

  _resetButton() {
    final _recordProvider =
        Provider.of<RecordAudioProviders>(context, listen: false);

    return InkWell(
      onTap: () => _recordProvider.clearOldData(),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 110,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.black,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh_outlined, color: Colors.white, size: 30),
              SizedBox(width: 10),
              Text(
                'Reset',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
