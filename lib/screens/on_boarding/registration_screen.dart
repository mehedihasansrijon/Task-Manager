import 'package:flutter/material.dart';
import '../../api/api_client.dart';
import '../../style/style.dart';
import '../../widget/screen_background.dart';
import '../../widget/sign_in_widget.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailTextEdit = TextEditingController();
  final TextEditingController _firstNameTextEdit = TextEditingController();
  final TextEditingController _lastNameTextEdit = TextEditingController();
  final TextEditingController _mobileTextEdit = TextEditingController();
  final TextEditingController _passwordTextEdit = TextEditingController();
  final TextEditingController _cPasswordTextEdit = TextEditingController();
  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _buildRegistrationForm(),
      ),
    );
  }

  SingleChildScrollView _buildRegistrationForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Join With Us',
              style: head1Text(colorDark),
            ),
            const SizedBox(
              height: 20,
            ),
            _buildForm(),
            const SizedBox(
              height: 20,
            ),
            _buildNextButton(),
            const SizedBox(height: 20),
            const SignInWidget(),
          ],
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _registrationFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTextEdit,
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
            controller: _firstNameTextEdit,
            keyboardType: TextInputType.name,
            decoration: inputDecoration('First Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'First Name Required';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _lastNameTextEdit,
            keyboardType: TextInputType.name,
            decoration: inputDecoration('Last Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Last Name Required';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _mobileTextEdit,
            keyboardType: TextInputType.phone,
            decoration: inputDecoration('Mobile'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mobile Required';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _passwordTextEdit,
            decoration: inputDecoration('Password'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _cPasswordTextEdit,
            decoration: inputDecoration('Confirm Password'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  ElevatedButton _buildNextButton() {
    return ElevatedButton(
      style: buttonStyle(),
      onPressed: () {
        _isLoading = true;
        setState(() {});

        if (_registrationFormKey.currentState!.validate()) {
          if (_passwordTextEdit.text == _cPasswordTextEdit.text) {
            registrationRequest(
              _emailTextEdit.text,
              _firstNameTextEdit.text,
              _lastNameTextEdit.text,
              _mobileTextEdit.text,
              _passwordTextEdit.text,
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
              (route) => false,
            );
          } else {
            toastMsg(
              'Passwords do not match. Please try again.',
              colorRed,
            );
          }
        }
        _isLoading = false;
        setState(() {});
      },
      child: const Icon(Icons.arrow_forward_ios),
    );
  }

  @override
  void dispose() {
    _emailTextEdit.dispose();
    _firstNameTextEdit.dispose();
    _lastNameTextEdit.dispose();
    _mobileTextEdit.dispose();
    _passwordTextEdit.dispose();
    _cPasswordTextEdit.dispose();
    super.dispose();
  }
}
