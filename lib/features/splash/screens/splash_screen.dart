import 'package:flutter/material.dart';
import '../../../core/core.export.dart';
import '../../features.export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(
      const Duration(
        seconds: 1,
      ),
    ).then(
      (value) => {openNewPage(context,  LoginScreen())},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset(
            'assets/images/logo.png',
            width: 400.0,
            height: 400.0,
          ),
          getCenterCircularProgress(),
        ],
      ),
    );
  }


}