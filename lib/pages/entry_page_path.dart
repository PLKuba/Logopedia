import 'package:flutter/material.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return entryPage(context);
  }

  Widget entryPage(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            width: MediaQuery.of(context).size.width,
            height: 200),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          child: const Text(
            'Logopedia',
          ),
        ),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/startLearning');
              },
              child: const Text('Start Learning')),
        )
      ],
      // change background to white
    );
  }
}