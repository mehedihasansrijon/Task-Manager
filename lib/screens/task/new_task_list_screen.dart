import 'package:flutter/material.dart';
import 'package:task_manager/api/api_client.dart';
import 'package:task_manager/component/task_list.dart';
import 'package:task_manager/models/task_list_model.dart';
import 'package:task_manager/screens/task/add_new_task.dart';
import 'package:task_manager/utility/utility.dart';

import '../../widget/task_summary_card.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  Map<dynamic, dynamic> taskStatusCountMap = {};
  List<TaskListModel>? taskList = [];
  bool isNothingTaskList = true;
  String progress = "Loading";

  @override
  void initState() {
    super.initState();
    taskStatusCount();
    taskListData('New');
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

  Future<void> taskStatusCount() async {
    taskStatusCountMap.clear();
    String? token = await readUserData('token');
    if (token!.isNotEmpty) {
      Map<String, dynamic>? taskStatusCountData = await taskStatusCountRequest(token);
      if (taskStatusCountData == null) {
        return;
      }
      if (taskStatusCountData['data'] != null) {
        setState(() {
          for (var item in taskStatusCountData['data']) {
            taskStatusCountMap[item['_id']] = item['sum'];
          }
        });
      }
    }
  }

  void onTapRefresh() {
    taskStatusCount();
    taskListData('New');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildSummarySection(taskStatusCountMap),
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
                          onTapRefresh();
                        });
                      },
                    ),
                  ),
                )
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  FloatingActionButton _buildFAB() {
    return FloatingActionButton(
      onPressed: onTapFAB,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  void onTapFAB() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTask(),
      ),
    );
  }

  Padding _buildSummarySection(Map<dynamic, dynamic> taskStatusCountMap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Row(
              children: [
                TaskSummaryCard(
                  title: "New Task",
                  count: taskStatusCountMap['New'] ?? 0,
                ),
                TaskSummaryCard(
                  title: "Completed",
                  count: taskStatusCountMap['Completed'] ?? 0,
                ),
                TaskSummaryCard(
                  title: "Canceled",
                  count: taskStatusCountMap['Canceled'] ?? 0,
                ),
                TaskSummaryCard(
                  title: "Progress",
                  count: taskStatusCountMap['Progress'] ?? 0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
