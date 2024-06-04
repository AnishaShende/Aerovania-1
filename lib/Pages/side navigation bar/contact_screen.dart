import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    const email = 'aerovaniaofficial@gmail.com';

    List<String> links = [
      'https://www.linkedin.com/company/aerovania/', // LinkedIn
      'https://www.instagram.com/aerovania_/', // Instagram
      'https://youtube.com/@aerovania9787', // YouTube
      'https://chat.whatsapp.com/HF0o37lbdox9ctrpWQVD88', // WhatsApp
      // 'tel:$phoneNumber',
      'mailto:$email',
    ];

    Future _launchURLApp({
      required String url,
    }) async {
      var a = Uri.parse(url);

      if (await canLaunchUrl(a)) {
        await launchUrl(a);
      } else {
        const SnackBar(
          content: Text('Could not launch url'),
        );
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xffbfe0f8),
      appBar: AppBar(
        title: const Text(
          "Contact Us",
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // backgroundColor: const Color(0xffbfe0f8),
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      // body: _buildUserList(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 4,
                        color: Theme.of(context).scaffoldBackgroundColor),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 10))
                    ],
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'assets/images/applogo.png',
                        ))),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Aerovania',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      _launchURLApp(url: links[0]);
                    },
                    child: Container(
                      height: height * 0.07,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.black54,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                          // bottomRight: Radius.circular(50),
                          // topRight: Radius.circular(50.0),
                        ),
                        color: Colors.white70,
                      ),
                      child: const Center(
                          child: Text(
                        'LinkedIn',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      _launchURLApp(url: links[1]);
                    },
                    child: Container(
                      height: height * 0.07,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.black54,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                          // bottomRight: Radius.circular(50),
                          // topRight: Radius.circular(50.0),
                        ),
                        color: Colors.white70,
                      ),
                      child: const Center(
                          child: Text(
                        'Instagram',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      _launchURLApp(url: links[2]);
                    },
                    child: Container(
                      height: height * 0.07,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.black54,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                          // bottomRight: Radius.circular(50),
                          // topRight: Radius.circular(50.0),
                        ),
                        color: Colors.white70,
                      ),
                      child: const Center(
                          child: Text(
                        'YouTube',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      _launchURLApp(url: links[3]);
                    },
                    child: Container(
                      height: height * 0.07,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.black54,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                          // bottomRight: Radius.circular(50),
                          // topRight: Radius.circular(50.0),
                        ),
                        color: Colors.white70,
                      ),
                      child: const Center(
                          child: Text(
                        'WhatsApp',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      _launchURLApp(url: links[3]);
                    },
                    child: Container(
                      height: height * 0.09,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.black54,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                          // bottomRight: Radius.circular(50),
                          // topRight: Radius.circular(50.0),
                        ),
                        color: Colors.white70,
                      ),
                      child: const Center(
                          child: Wrap(
                        children: [
                          Text(
                            'Register for our Drone Workshop',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: IconButton(
                        onPressed: () {
                          _launchURLApp(url: links[0]);
                        },
                        icon: Image.asset('assets/icons/social/linkedin.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: IconButton(
                        onPressed: () {
                          _launchURLApp(url: links[1]);
                        },
                        icon: Image.asset('assets/icons/social/instagram.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: IconButton(
                        onPressed: () {
                          _launchURLApp(url: links[2]);
                        },
                        icon: Image.asset('assets/icons/social/youtube.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: IconButton(
                        onPressed: () {
                          _launchURLApp(url: links[3]);
                        },
                        icon: Image.asset('assets/icons/social/whatsapp.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: IconButton(
                        onPressed: () {
                          _launchURLApp(url: links[4]);
                        },
                        icon: Image.asset('assets/icons/social/gmail.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
