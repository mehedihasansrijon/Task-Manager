import 'package:flutter/material.dart';
import 'package:task_manager/api/api_client.dart';
import 'package:task_manager/models/task_list_model.dart';
import 'package:task_manager/style/style.dart';

import '../utility/utility.dart';

class TaskList extends StatefulWidget {
  final List<TaskListModel> taskData;
  final VoidCallback onTapRefresh;

  const TaskList({
    super.key,
    required this.taskData,
    required this.onTapRefresh,
  });

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  int radioValue = 1;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.taskData.length,
      itemBuilder: (context, index) {
        TaskListModel taskListModel = widget.taskData[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: _buildGrid(taskListModel, context),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 12,
        );
      },
    );
  }

  Padding _buildGrid(
    TaskListModel taskListModel,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            taskListModel.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            taskListModel.description,
            maxLines: 2,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Date: ${taskListModel.createdDate.substring(0, 10)}",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(
            height: 4,
          ),
          _buildButton(taskListModel),
        ],
      ),
    );
  }

  Row _buildButton(TaskListModel taskListModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Chip(
          label: Text(
            taskListModel.status,
          ),
          side: const BorderSide(
            color: Colors.green,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => onTapEditButton(taskListModel.id),
              icon: const Icon(
                Icons.edit_note_outlined,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () => onTapDeleteButton(taskListModel.id),
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void onTapEditButton(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Status"),
          content: _buildDialogContent(),
          actions: [
            _buildCancelButton(context),
            _buildUpdateButton(id, context),
          ],
        );
      },
    );
  }

  MaterialButton _buildCancelButton(BuildContext context) {
    return MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          );
  }

  MaterialButton _buildUpdateButton(String id, BuildContext context) {
    return MaterialButton(
            onPressed: () async {
              String status = getRadioItemName(radioValue);
              String? token = await readUserData('token');
              Future<bool> update = updateTaskRequest(id, token!, status);
              if (await update) {
                toastMsg('Updated', colorGreen);
                widget.onTapRefresh();
              } else {
                toastMsg('Failed', colorRed);
              }
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          );
  }

  String getRadioItemName(int value) {
    switch (value) {
      case 1:
        return "New";
      case 2:
        return "Completed";
      case 3:
        return "Canceled";
      case 4:
        return "Progress";
      default:
        return "None";
    }
  }

  void onTapDeleteButton(String taskListID) async {
    String? token = await readUserData('token');
    bool delete = await deleteTaskRequest(taskListID, token!);
    if (delete) {
      widget.onTapRefresh();
      toastMsg('Task removed successfully.', colorGreen);
    } else {
      toastMsg('Failed to delete the task.', colorRed);
    }
  }

  StatefulBuilder _buildDialogContent() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Radio(
                  value: 1,
                  groupValue: radioValue,
                  onChanged: (value) {
                    setState(() {
                      radioValue = value as int;
                    });
                  },
                ),
                const SizedBox(width: 10),
                const Text("New"),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 2,
                  groupValue: radioValue,
                  onChanged: (value) {
                    setState(() {
                      radioValue = value as int;
                    });
                  },
                ),
                const SizedBox(width: 10),
                const Text("Completed"),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 3,
                  groupValue: radioValue,
                  onChanged: (value) {
                    setState(() {
                      radioValue = value as int;

                    });
                  },
                ),
                const SizedBox(width: 10),
                const Text("Canceled"),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 4,
                  groupValue: radioValue,
                  onChanged: (value) {
                    setState(() {
                      radioValue = value as int;
                    });
                  },
                ),
                const SizedBox(width: 10),
                const Text("Progress"),
              ],
            ),
          ],
        );
      },
    );
  }
}
