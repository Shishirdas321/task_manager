import 'package:flutter/material.dart';
import 'package:task_manager/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/widgets/screen_background.dart';
import 'package:task_manager/widgets/task_item_widget.dart';
import 'package:task_manager/widgets/tm_app_bar.dart';

import '../../data/models/services/network_caller.dart';
import '../../data/models/task_list_by_status_model.dart';
import '../../data/utills/urls.dart';
import '../../widgets/snack_bar_message.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
  TaskListByStatusModel? cancelledTaskListModel;
  bool _getCancelledListInProgress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCancelledList();
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
              visible: _getCancelledListInProgress == false,
              replacement:  const CenteredCircularProgressIndicator(),
              child: _buildTaskListView()),
        ),
      ),
    );
  }

  Widget _buildTaskListView() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: cancelledTaskListModel?.taskList?.length ?? 0,
      itemBuilder: (context, index) {
        return  TaskItemWidget(
          taskModel:  cancelledTaskListModel!.taskList![index],
        );
      },
    );
  }
  Future<void> _getCancelledList() async{
    _getCancelledListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskListByStatusUrl('Cancelled'));
    if(response.isSuccess){
      cancelledTaskListModel = TaskListByStatusModel.fromJson(response.responseData!);
    }else{
      showSnackBarMessage(context, response.errorMessage);
    }
    _getCancelledListInProgress = false;
    setState(() {});
  }
}


