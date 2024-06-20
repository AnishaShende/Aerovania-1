import 'package:aerovania_app_1/Pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late WebViewController _controller;
  final controller = SidebarXController(selectedIndex: 6, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            Center(
              child: CircularProgressIndicator(
                value: progress.toDouble(),
              ),
            );
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  void _launchURL(String url) {
    _controller.loadRequest(Uri.parse(url));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("WebView"),
          ),
          body: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }

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
      'mailto:$email',
    ];

    return Scaffold(
      key: _key,
      drawer: ExampleSidebarX(controller: controller),
      backgroundColor: const Color(0xffbfe0f8),
      appBar: AppBar(
        title: const Text(
          "Contact Us",
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
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
                        image: AssetImage(
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
              ...links.map((link) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(link);
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
                          ),
                          color: Colors.white70,
                        ),
                        child: Center(
                            child: Text(
                          link.contains('linkedin')
                              ? 'LinkedIn'
                              : link.contains('instagram')
                                  ? 'Instagram'
                                  : link.contains('youtube')
                                      ? 'YouTube'
                                      : link.contains('whatsapp')
                                          ? 'WhatsApp'
                                          : 'Email',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        )),
                      ),
                    ),
                  ),
                );
              }).toList(),
              SizedBox(
                height: height * 0.01,
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
                          _launchURL(links[0]);
                        },
                        icon: Image.asset('assets/icons/social/linkedin.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: IconButton(
                        onPressed: () {
                          _launchURL(links[1]);
                        },
                        icon: Image.asset('assets/icons/social/instagram.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: IconButton(
                        onPressed: () {
                          _launchURL(links[2]);
                        },
                        icon: Image.asset('assets/icons/social/youtube.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: IconButton(
                        onPressed: () {
                          _launchURL(links[3]);
                        },
                        icon: Image.asset('assets/icons/social/whatsapp.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: IconButton(
                        onPressed: () {
                          _launchURL(links[4]);
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
