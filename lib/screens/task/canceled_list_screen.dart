import 'package:flutter/material.dart';

import '../../api/api_client.dart';
import '../../component/task_list.dart';
import '../../models/task_list_model.dart';
import '../../utility/utility.dart';

class CanceledListScreen extends StatefulWidget {
  const CanceledListScreen({super.key});

  @override
  State<CanceledListScreen> createState() => _CanceledListScreenState();
}

class _CanceledListScreenState extends State<CanceledListScreen> {
  Map<dynamic, dynamic> taskStatusCountMap = {};
  List<TaskListModel>? taskList = [];
  bool isNothingTaskList = true;
  String progress = "Loading";

  @override
  void initState() {
    super.initState();
    taskListData('Canceled');
  }

  Future<void> taskListData(String status) async {
    taskList?.clear();
    String? token = await readUserData('token');

    if (token != null && token.isNotEmpty) {
      taskList = await listTaskByStatusRequest(status, token);

      if (taskList != null) {
        if (taskList!.isEmpty) {
          isNothingTaskList = true;
          progress = "No items found.";
        } else {
          isNothingTaskList = false;
        }
      } else {
        isNothingTaskList = true;
        progress = "Failed to fetch tasks.";
      }
    } else {
      isNothingTaskList = true;
      progress = "User not authenticated.";
    }

    setState(() {});
  }

  void onTapRefresh() {
    taskListData('Canceled');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isNothingTaskList
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(progress),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isNothingTaskList = true;
                            progress = "Loading";
                          });
                          onTapRefresh();
                        },
                        child: const Text("Refresh"),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RefreshIndicator(
                      child: TaskList(
                        taskData: taskList!,
                        onTapRefresh: onTapRefresh,
                      ),
                      onRefresh: () async {
                        setState(() {
                          isNothingTaskList = true;
                          progress = "Loading";
                        });
                        onTapRefresh();
                      },
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
