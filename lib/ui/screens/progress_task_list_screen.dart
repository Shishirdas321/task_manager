import 'package:flutter/material.dart';
import 'package:task_manager/data/models/services/network_caller.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/utills/urls.dart';
import 'package:task_manager/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/widgets/screen_background.dart';
import 'package:task_manager/widgets/snack_bar_message.dart';
import 'package:task_manager/widgets/task_item_widget.dart';
import 'package:task_manager/widgets/tm_app_bar.dart';

import '../../data/models/task_list_by_status_model.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});
  static const String name = '/progress-task-list';

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  //TaskListByStatusModel? progressTaskListModel;
  List<TaskModel> progressTask =[];
  bool _getProgressListInProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProgressList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Visibility(
              visible: _getProgressListInProgress == false,
              replacement: const CenteredCircularProgressIndicator(),
              child: _buildProgressTaskListView()),
        ),
      ),
    );
  }

  Widget _buildProgressTaskListView() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: progressTask.length ?? 0,
      itemBuilder: (context, index) {
        final task = progressTask[index];
        return  TaskItemWidget(
          taskModel: task,
          taskColor: Colors.amberAccent,
          status: 'Progress',

        );
      },
    );
  }

  Future<void> _getProgressList() async {
    setState(() {
      _getProgressListInProgress = true;
    });

    final response = await NetworkCaller.getRequest(
      url: Urls.taskListByStatusUrl('Progress'),
    );

    if (response.isSuccess && response.responseData != null) {
      try{
        final responseData = response.responseData;
        final taskListModel = TaskListByStatusModel.fromJson(responseData!);
        setState(() {
          progressTask = taskListModel.taskList ?? [];
        });
      }catch(e){
        debugPrint('failed to parse task list: $e');
      }
    } else {
      // Handle error or show a message
      debugPrint('Failed to fetch tasks: ${response.errorMessage}');
    }

    setState(() {
      _getProgressListInProgress = false;
    });
  }

}


