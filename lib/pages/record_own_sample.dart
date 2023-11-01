import 'package:flutter/material.dart';
import 'package:logopedia/pages/create_sample_card_screen.dart';
import 'package:logopedia/providers/play_audio_provider.dart';
import 'package:logopedia/providers/record_audio_provider.dart';
import 'package:provider/provider.dart';

class RecordOwnSample extends StatelessWidget {
  const RecordOwnSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return recordOwnSample(context);
  }

  Widget recordOwnSample(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: buildRecordSampleCard(context)
      ),
    );
  }

  Widget buildRecordSampleCard(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecordAudioProviders()),
        ChangeNotifierProvider(create: (_) => PlayAudioProvider()),
        ChangeNotifierProvider(create: (_) => PlayExampleAudioProvider())
      ],
      builder: (context, child) {
        return const CreateSampleCardScreen();
      },
    );
  }
}
