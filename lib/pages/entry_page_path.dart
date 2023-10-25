import 'package:flutter/material.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(child: entryPage(context));
  }

  Widget entryPage(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200),
              const Text('Logopedia', style: TextStyle(color: Colors.black, fontSize: 50),),
              const SizedBox(height: 50,),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/startLearning', (Route<dynamic> route) => false);
                },
                child: const Text('Start Learning'),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
              ),)
        ],
      ),
    );
  }
}
