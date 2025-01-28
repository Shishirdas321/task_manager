import 'package:flutter/material.dart';
import 'package:task_manager/data/models/services/network_caller.dart';
import 'package:task_manager/data/utills/urls.dart';
import 'package:task_manager/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/widgets/screen_background.dart';
import 'package:task_manager/widgets/snack_bar_message.dart';
import 'package:task_manager/widgets/task_item_widget.dart';
import 'package:task_manager/widgets/tm_app_bar.dart';

import '../../data/models/task_list_by_status_model.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  TaskListByStatusModel? progressTaskListModel;
  bool _getProgressListInProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProgressList();
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
      itemCount: progressTaskListModel?.taskList?.length ?? 0,
      itemBuilder: (context, index) {

        return  TaskItemWidget(
          taskModel: progressTaskListModel!.taskList![index],
        );
      },
    );
  }

  Future<void> _getProgressList() async{
    _getProgressListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskListByStatusUrl('Progress'));
    if(response.isSuccess){
      progressTaskListModel = TaskListByStatusModel.fromJson(response.responseData!);
    }else{
      showSnackBarMessage(context, response.errorMessage);
    }
    _getProgressListInProgress = false;
    setState(() {});
  }

}


