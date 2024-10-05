import 'package:flutter/material.dart';
import '../../api/api_client.dart';
import '../../style/style.dart';
import '../../widget/screen_background.dart';
import '../task/main_content_screen.dart';
import 'email_verification_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditText = TextEditingController();
  final TextEditingController _passwordEditText = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _buildLoginForm(context),
      ),
    );
  }

  SingleChildScrollView _buildLoginForm(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get Started With',
              style: head1Text(colorDark),
            ),
            const SizedBox(
              height: 1,
            ),
            Text(
              'Learn with our team',
              style: head6Text(colorLightGray),
            ),
            const SizedBox(
              height: 20,
            ),
            _buildForm(),
            _buildLoginButton(context),
            const SizedBox(
              height: 40,
            ),
            _buildEmailVerification(context),
            const SizedBox(
              height: 5,
            ),
            _buildSignUp(context),
          ],
        ),
      ),
    );
  }

  InkWell _buildSignUp(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegistrationScreen(),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have account?",
            style: head6Text(
              colorDarkBlue,
            ).copyWith(fontSize: 12),
          ),
          Text(
            'Sign up',
            style: head6Text(
              colorGreen,
            ).copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Center _buildEmailVerification(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EmailVerificationScreen(),
            ),
          );
        },
        child: Text(
          'Forgot Password?',
          style: head6Text(
            colorLight,
          ).copyWith(fontSize: 12),
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailEditText,
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
          TextFormField(
            controller: _passwordEditText,
            obscureText: true,
            decoration: inputDecoration('Password'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password Required';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  ElevatedButton _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      style: buttonStyle(),
      onPressed: onTapLoginButton,
      child: successButtonChild(
        const Icon(
          Icons.arrow_forward_ios,
        ),
      ),
    );
  }

  void onTapLoginButton() async {
    _isLoading = true;
    setState(() {});
    if (_loginFormKey.currentState!.validate()) {
      bool isLogin = await loginRequest(
        _emailEditText.text,
        _passwordEditText.text,
      );
      if (isLogin) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainContentScreen(),
          ),
          (route) => false,
        );
      }
    }
    _isLoading = false;
    setState(() {});
  }
}
