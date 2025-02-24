import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/widgets/screen_background.dart';
import 'package:task_manager/widgets/task_item_widget.dart';
import 'package:task_manager/widgets/tm_app_bar.dart';

import '../../data/models/services/network_caller.dart';
import '../../data/models/task_list_by_status_model.dart';
import '../../data/utills/urls.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});
  static const String name = '/cancelled-task-list';

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
 List<TaskModel> cancelledTask = [];
  //TaskListByStatusModel? cancelledTaskListModel;
  bool _getCancelledListInProgress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCancelledList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: Visibility(
            visible: _getCancelledListInProgress == false,
            replacement:  const CenteredCircularProgressIndicator(),
            child: _buildTaskListView()),
      ),
    );
  }

  Widget _buildTaskListView() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: cancelledTask.length ?? 0,
      itemBuilder: (context, index) {
        final task = cancelledTask[index];
        return  TaskItemWidget(
          taskModel:  task,
          taskColor: Colors.red, status: 'Cancelled',
        );
      },
    );
  }
 Future<void> _getCancelledList() async {
   setState(() {
     _getCancelledListInProgress = true;
   });

   final response = await NetworkCaller.getRequest(
     url: Urls.taskListByStatusUrl('Canceled'),
   );

   if (response.isSuccess && response.responseData != null) {
     try{
       final responseData = response.responseData;
       final taskListModel = TaskListByStatusModel.fromJson(responseData!);
       setState(() {
         cancelledTask = taskListModel.taskList ?? [];
       });
     }catch(e){
       debugPrint('Failed to parse task list: $e');
     }
   } else {
     // Handle error or show a message
     debugPrint('Failed to fetch tasks: ${response.errorMessage}');
   }

   setState(() {
     _getCancelledListInProgress = false;
   });
 }
}


