import 'package:flutter/material.dart';
import '../../api/api_client.dart';
import '../../style/style.dart';
import '../../widget/screen_background.dart';
import '../../widget/sign_in_widget.dart';
import 'login_screen.dart';

class SetPasswordScreen extends StatefulWidget {
  final String email, otp;

  const SetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _passwordTextEdit = TextEditingController();
  final TextEditingController _cPasswordTextEdit = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: _buildSetPassword(),
      ),
    );
  }

  Padding _buildSetPassword() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set Password',
            style: head1Text(colorDark),
          ),
          const SizedBox(
            height: 1,
          ),
          Text(
            'Minimum length password 8 character with Letter and number combination',
            style: head6Text(colorLightGray),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _passwordTextEdit,
            decoration: inputDecoration('Password'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _cPasswordTextEdit,
            decoration: inputDecoration('Confirm Password'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: buttonStyle(),
            onPressed: onTapConfirmButton,
            child: successButtonChild(
              Text(
                "Confirm",
                style: buttonTextStyle(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SignInWidget(),
        ],
      ),
    );
  }

  void onTapConfirmButton() async {
    if (_passwordTextEdit.text.length < 8 ||
        _passwordTextEdit.text.length < 8) {
      toastMsg('Minimum length password 8 character', colorRed);
    } else {
      if (_passwordTextEdit.text == _cPasswordTextEdit.text) {
        bool isChangePassword = await changePasswordRequest(
            widget.email, widget.otp, _passwordTextEdit.text);
        if (isChangePassword) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false,
          );
        }
      } else {
        toastMsg(
            'Both password fields must contain the same password.', colorRed);
      }
    }
  }
}
