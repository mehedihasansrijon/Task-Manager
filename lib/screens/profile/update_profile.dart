import 'package:flutter/material.dart';
import 'package:task_manager/api/api_client.dart';
import 'package:task_manager/screens/task/main_content_screen.dart';
import 'package:task_manager/utility/utility.dart';
import 'package:task_manager/widget/screen_background.dart';
import 'package:task_manager/component/tm_app_bar.dart';

import '../../style/style.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController _emailTextEdit = TextEditingController();
  final TextEditingController _firstNameTextEdit = TextEditingController();
  final TextEditingController _lastNameTextEdit = TextEditingController();
  final TextEditingController _mobileTextEdit = TextEditingController();
  final TextEditingController _passwordTextEdit = TextEditingController();
  final GlobalKey<FormState> _updateFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() async {
    _emailTextEdit.text = (await readUserData('email')) ?? '';
    _firstNameTextEdit.text = (await readUserData('firstName')) ?? '';
    _lastNameTextEdit.text = (await readUserData('lastName')) ?? '';
    _mobileTextEdit.text = (await readUserData('mobile')) ?? '';
    _passwordTextEdit.text = (await readUserData('password')) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        isAppBarScreenOpen: true,
      ),
      body: ScreenBackground(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _buildUpdateForm(),
      ),
    );
  }

  Widget _buildUpdateForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 52,
                ),
                Text(
                  'Update Profile',
                  style: head1Text(colorDark),
                ),
                const SizedBox(
                  height: 16,
                ),
                _buildForm(),
                _buildNextButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _updateFormKey,
      child: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  height: double.infinity,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Photo",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                const Text(
                  "Select Photo",
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
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
            obscureText: true,
            decoration: inputDecoration('Password'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              } else if (value.length < 8) {
                return 'Minimum 8 character';
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

  ElevatedButton _buildNextButton() {
    return ElevatedButton(
      style: buttonStyle(),
      onPressed: () async {
        _isLoading = true;
        setState(() {});

        if (_updateFormKey.currentState!.validate()) {
          String? userMail = await readUserData('email');
          String? token = await readUserData('token');
          if (userMail == _emailTextEdit.text) {
            bool update = await updateProfileRequest(
              token!,
              userMail!,
              _firstNameTextEdit.text,
              _lastNameTextEdit.text,
              _mobileTextEdit.text,
              _passwordTextEdit.text,
            );

            if (update) {
              bool profileDetails = await profileDetailsRequest(token);
              if (profileDetails) {
                toastMsg('Your data update was successful.', colorGreen);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainContentScreen(),
                  ),
                  (route) => false,
                );
              } else {
                toastMsg('There was an issue retrieving your data locally',
                    colorRed);
              }
            } else {
              toastMsg('Your data update was unsuccessful.', colorRed);
            }
          } else {
            toastMsg('The primary user email cannot be changed.', colorRed);
          }
        }
        _isLoading = false;
        setState(() {});
      },
      child: successButtonChild(
        const Icon(
          Icons.arrow_forward_ios,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailTextEdit.dispose();
    _firstNameTextEdit.dispose();
    _lastNameTextEdit.dispose();
    _mobileTextEdit.dispose();
    _passwordTextEdit.dispose();
    super.dispose();
  }
}
