import 'package:flutter/material.dart';
import '../screens/on_boarding/login_screen.dart';
import '../style/style.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>  LoginScreen(),
            ),
            (route) => false);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Have account?",
            style: head6Text(
              colorDarkBlue,
            ).copyWith(fontSize: 12),
          ),
          Text(
            'Sign In',
            style: head6Text(
              colorGreen,
            ).copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
