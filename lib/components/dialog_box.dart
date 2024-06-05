import 'package:flutter/material.dart';

class MyDialogBox extends StatelessWidget {
  const MyDialogBox(
      {super.key,
      required this.title,
      required this.onTapFunc,
      required this.content});

  final title;
  final content;
  final void onTapFunc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.4,
        child: AlertDialog(
          title: title,
          content: content,
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                // Put your code here which you want to execute on Confirm button click.
                Navigator.of(context).pop();
                onTapFunc;
              },
            ),
          ],
        ),
      ),
    );
  }
}
