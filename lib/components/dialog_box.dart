import 'package:flutter/material.dart';

class MyDialogBox extends StatelessWidget {
  
  final String text;
  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;

  MyDialogBox({
    Key? key,
    required this.text,
    required this.onYesPressed,
    required this.onNoPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.4,
        
        child: AlertDialog(
          
          backgroundColor: Colors.transparent,
          content: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            // style: NeumorphicStyle(
            //   shape: NeumorphicShape.concave,
            //   boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            //   depth: 4,
            //   intensity: 0.65,
            // ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    
                    text,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 16),
                  Row(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: onYesPressed,
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(3.0),
                        ),
                        //  NeumorphicStyle(
                        //   shape: NeumorphicShape.flat,
                        //   boxShape: NeumorphicBoxShape.roundRect(
                        //       BorderRadius.circular(8.0)),
                        //   depth: 4,
                        //   intensity: 0.8,
                        // ),
                        child: Text('Yes'),
                      ),
                      ElevatedButton(
                        onPressed: onNoPressed,
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(3.0),
                        ),
                        // NeumorphicStyle(
                        //   shape: NeumorphicShape.flat,
                        //   boxShape: NeumorphicBoxShape.roundRect(
                        //       BorderRadius.circular(8.0)),
                        //   depth: 4,
                        //   intensity: 0.8,
                        // ),
                        child: Text('No'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}

