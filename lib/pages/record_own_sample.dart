// import 'package:flutter/material.dart';
// import 'package:logopedia/providers/card_provider.dart';
// import 'package:logopedia/pages/create_sample_card_screen.dart';
// import 'package:logopedia/providers/play_audio_provider.dart';
// import 'package:logopedia/providers/record_audio_provider.dart';
// import 'package:provider/provider.dart';

// class RecordOwnSample extends StatelessWidget {
//   const RecordOwnSample({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: recordOwnSample(context));
//   }

//   Widget recordOwnSample(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: MultiProvider(
//             providers: [
//               ChangeNotifierProvider(create: (_) => CardProvider()),
//             ],
//             builder: (context, child) {
//               return buildRecordSampleCard(context);
//             }),
//       ),
//     );
//   }

//   Widget buildRecordSampleCard(BuildContext context) {
//     final provider = Provider.of<CardProvider>(context);
//     final words = provider.words;
//     final paths = provider.paths;
//     final imagePaths = provider.imagePaths;

//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => RecordAudioProviders()),
//         ChangeNotifierProvider(create: (_) => PlayAudioProvider())
//       ],
//       builder: (context, child) {
//         return const CreateSampleCardScreen();
//       },
//     );
//   }
// }
