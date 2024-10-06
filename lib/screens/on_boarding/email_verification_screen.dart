import 'package:flutter/material.dart';
import '../../api/api_client.dart';
import '../../style/style.dart';
import '../../widget/screen_background.dart';
import '../../widget/sign_in_widget.dart';
import 'pin_verification_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailEditTex = TextEditingController();
  final GlobalKey<FormState> _emailVerificationKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _buildEmailVerification(context),
      ),
    );
  }

  Padding _buildEmailVerification(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Form(
        key: _emailVerificationKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Email Address',
              style: head1Text(colorDark),
            ),
            const SizedBox(
              height: 1,
            ),
            Text(
              'A 6 digit verification pin will send to your email address',
              style: head6Text(colorLightGray),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _emailEditTex,
              keyboardType: TextInputType.emailAddress,
              decoration: inputDecoration('Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email Required';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: buttonStyle(),
              onPressed: () => onTapNextButton(),
              child: successButtonChild(
                const Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SignInWidget(),
          ],
        ),
      ),
    );
  }

  void onTapNextButton() async {
    _isLoading = true;
    setState(() {});
    if (_emailVerificationKey.currentState!.validate()) {
      bool isLogin = await recoveryEmailVerifyRequest(
        _emailEditTex.text,
      );
      if (isLogin) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => PinVerificationScreen(
                email: _emailEditTex.text,
              ),
            ),
            (route) => false);
      }
    }
    _isLoading = false;
    setState(() {});
  }
}
