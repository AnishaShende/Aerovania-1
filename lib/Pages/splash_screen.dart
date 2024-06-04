import 'package:aerovania_app_1/services/auth/auth_gate.dart';
import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // late final AnimationController _controller;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEAEA),
      body: Center(
        child: FlutterSplashScreen.fadeIn(
          duration: Duration(milliseconds: 4000),
          backgroundColor: Colors.white,
          onInit: () {
            debugPrint("On Init");
          },
          onEnd: () {
            debugPrint("On End");
          },
          childWidget: SizedBox(
            height: 200,
            width: 200,
            child: Image.asset("assets/images/applogo.png"),
          ),
          onAnimationEnd: () => debugPrint("On Fade In End"),
          nextScreen: const AuthGate(),
        ),
        // child: Column(
        //   children: [
        // Lottie.network(
        //     "https://assets10.lottiefiles.com/packages/lf20_nhmiuj9f.json",
        //     controller: _controller, onLoaded: (compos) {
        //   _controller
        //     ..duration = compos.duration
        //     ..forward().then((value) => Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => AuthGate())));
        // }),
        // Text("AirChat", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF333333),),),
        //   ],
        // ),
      ),
    );
  }
}
