import 'package:flutter/material.dart';
import 'package:task_manager/api/api_client.dart';
import '../../style/style.dart';
import '../../utility/utility.dart';
import '../../widget/screen_background.dart';
import '../task/main_content_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? token;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Container(
          alignment: Alignment.center,
          child: logoSvg(),
        ),
      ),
    );
  }

  void getToken() async {
    token = await readUserData('token');

    navigateBasedOnToken();
  }

  void navigateBasedOnToken() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (token == null || token!.isEmpty) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );
    } else {
      bool profileDetails = await profileDetailsRequest(token!);
      if (profileDetails) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainContentScreen(),
          ),
          (route) => false,
        );
      } else {
        toastMsg(
            'The provided token is not valid. Please re-enter it.', colorRed);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    }
  }
}
