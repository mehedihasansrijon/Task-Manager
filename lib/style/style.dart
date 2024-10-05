import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../utility/assets_path.dart';

const colorRed = Color.fromRGBO(231, 28, 36, 1);
const colorDark = Color.fromRGBO(136, 28, 32, 1);
const colorGreen = Color.fromRGBO(33, 191, 115, 1);
const colorBlue = Color.fromRGBO(52, 152, 219, 1.0);
const colorOrange = Color.fromRGBO(230, 126, 34, 1.0);
const colorWhite = Color.fromRGBO(255, 255, 255, 1.0);
const colorDarkBlue = Color.fromRGBO(44, 62, 80, 1.0);
const colorLightGray = Color.fromRGBO(135, 142, 150, 1.0);
const colorLight = Color.fromRGBO(211, 211, 211, 1.0);

SvgPicture screenBackground(BuildContext context) {
  return SvgPicture.asset(
    AssetsPath.screenBackground,
    alignment: Alignment.center,
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    fit: BoxFit.cover,
  );
}

TextStyle head1Text(Color color) {
  return TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: 'poppins',
    color: color,
  );
}

TextStyle head6Text(Color color) {
  return TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontFamily: 'poppins',
    color: color,
  );
}

InputDecoration inputDecoration(String label) {
  return InputDecoration(
    border: const OutlineInputBorder(),
    fillColor: Colors.white,
    filled: true,
    labelText: label,
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: colorGreen, width: 1),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: colorWhite, width: 0.0),
    ),
  );
}

ButtonStyle buttonStyle() {
  return ElevatedButton.styleFrom(
    elevation: 1,
    padding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    backgroundColor: Colors.transparent,
  );
}

TextStyle buttonTextStyle() {
  return const TextStyle(
    fontSize: 14,
    fontFamily: 'poppins',
    fontWeight: FontWeight.w400,
  );
}

Ink successButtonChild(Widget child) {
  return Ink(
    decoration: BoxDecoration(
        color: colorGreen, borderRadius: BorderRadius.circular(6)),
    child: Container(
      height: 45,
      alignment: Alignment.center,
      child: child,
      //Icon(
      // Icons.arrow_forward_ios,
      //),
      //child: Text(
      //   buttonText,
      //   style: buttonTextStyle(),
      // ),
    ),
  );
}

PinTheme pinTheme() {
  return PinTheme(
    inactiveColor: colorLight,
    inactiveFillColor: colorWhite,
    activeColor: colorWhite,
    activeFillColor: colorWhite,
    selectedColor: colorGreen,
    selectedFillColor: colorGreen,
    shape: PinCodeFieldShape.box,
    borderRadius: BorderRadius.circular(5),
    fieldHeight: 50,
    fieldWidth: 45,
    borderWidth: 0.5,
  );
}

Future<bool?> toastMsg(String msg, Color color) {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

SvgPicture logoSvg() {
  return SvgPicture.asset(AssetsPath.logoSvg);
}
