import 'package:flutter/material.dart';
import 'package:task_manager/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/widgets/screen_background.dart';
import 'package:task_manager/widgets/task_item_widget.dart';
import 'package:task_manager/widgets/tm_app_bar.dart';

import '../../data/models/services/network_caller.dart';
import '../../data/models/task_list_by_status_model.dart';
import '../../data/utills/urls.dart';
import '../../widgets/snack_bar_message.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  TaskListByStatusModel? completedTaskListModel;
  bool _getCompletedListInProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCompletedList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Visibility(
              visible: _getCompletedListInProgress == false,
              replacement: const CenteredCircularProgressIndicator(),
              child: _buildTaskListView()),
        ),
      ),
    );
  }

  Widget _buildTaskListView() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount:  completedTaskListModel?.taskList?.length ?? 0,
      itemBuilder: (context, index) {
        return  TaskItemWidget(
          taskModel: completedTaskListModel!.taskList![index],
        );
      },
    );
  }
  Future<void> _getCompletedList() async{
    _getCompletedListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskListByStatusUrl('Completed'));
    if(response.isSuccess){
      completedTaskListModel = TaskListByStatusModel.fromJson(response.responseData!);
    }else{
      showSnackBarMessage(context, response.errorMessage);
    }
    _getCompletedListInProgress = false;
    setState(() {});
  }
}


