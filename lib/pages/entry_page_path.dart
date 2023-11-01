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
                  Navigator.of(context).pushNamed('/startLearning');
                },
                child: const Text('Rozpocznij grę'),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
              ),),
              const SizedBox(height: 50,),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/recordOwnSample');
                },
                child: const Text('Dodaj własne słówko'),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
              ),)
        ],
      ),
    );
  }
}
