import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../api/api_client.dart';
import '../../style/style.dart';
import '../../widget/screen_background.dart';
import '../../widget/sign_in_widget.dart';
import 'set_password_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  final String email;

  const PinVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final GlobalKey<FormState> _globalPinKey = GlobalKey<FormState>();
  late String _pin;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _buildPinVerification(context),
      ),
    );
  }

  Padding _buildPinVerification(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Form(
        key: _globalPinKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PIN Verification',
              style: head1Text(colorDark),
            ),
            const SizedBox(height: 1),
            Text(
              'A 6 digit verification pin will send to your mobile number',
              style: head6Text(colorLightGray),
            ),
            const SizedBox(height: 20),
            _buildPinCodeField(context),
            const SizedBox(height: 20),
            ElevatedButton(
              style: buttonStyle(),
              onPressed: _onTapVerification,
              child: successButtonChild(
                Text(
                  "Verify",
                  style: buttonTextStyle(),
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

  PinCodeTextField _buildPinCodeField(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      enableActiveFill: true,
      animationType: AnimationType.fade,
      animationDuration: const Duration(milliseconds: 300),
      pinTheme: pinTheme(),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        _pin = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 6) {
          return 'The PIN must be exactly 6 digits.';
        }
        return null;
      },
    );
  }

  void _onTapVerification() async {
    isLoading = true;
    setState(() {});

    if (_globalPinKey.currentState!.validate()) {
      bool emailOTPVerification =
          await recoveryEmailOTPRequest(widget.email, _pin);
      if (emailOTPVerification) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetPasswordScreen(
              email: widget.email,
              otp: _pin,
            ),
          ),
        );
      }
    } else {
      toastMsg('The PIN must be exactly 6 digits.', Colors.red);
    }

    isLoading = false;
    setState(() {});
  }
}
