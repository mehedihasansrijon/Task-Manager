import 'package:flutter/material.dart';
import 'package:task_manager/api/api_client.dart';
import 'package:task_manager/component/tm_app_bar.dart';
import '../../style/style.dart';
import '../../utility/utility.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final TextEditingController _subjectTEController = TextEditingController();
  final TextEditingController _descriptionEController = TextEditingController();
  final GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: _buildAddNewTask(),
    );
  }

  Padding _buildAddNewTask() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _globalFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 42,
            ),
            const Text(
              'Add New Task',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              controller: _subjectTEController,
              keyboardType: TextInputType.text,
              decoration: inputDecoration('Subject'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Subject Required';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _descriptionEController,
              keyboardType: TextInputType.text,
              maxLines: 5,
              decoration: inputDecoration('Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description Required';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              style: buttonStyle(),
              onPressed: onTapNextButton,
              child: successButtonChild(
                const Icon(Icons.arrow_forward_ios),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onTapNextButton() async {
    if (_globalFormKey.currentState!.validate()) {
      String? token = await readUserData('token');
      if (token!.isEmpty) {
        return;
      }
      bool createTask = await createTaskRequest(
          token, _subjectTEController.text, _descriptionEController.text);
      if (createTask) {
        toastMsg('Your new task has been added!', colorGreen);
        _subjectTEController.clear();
        _descriptionEController.clear();
      } else {
        toastMsg('Unable to add the task.', colorRed);
      }
    }
  }
}
