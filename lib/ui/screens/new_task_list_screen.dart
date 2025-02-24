import 'package:flutter/material.dart';
import 'package:task_manager/data/models/services/network_caller.dart';
import 'package:task_manager/data/models/task_count_by_status_model.dart';
import 'package:task_manager/data/models/task_count_model.dart';
import 'package:task_manager/data/models/task_list_by_status_model.dart';
import 'package:task_manager/data/utills/urls.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/widgets/screen_background.dart';
import 'package:task_manager/widgets/snack_bar_message.dart';
import 'package:task_manager/widgets/task_item_widget.dart';
import 'package:task_manager/widgets/task_status_summary_counter_widget.dart';
import 'package:task_manager/widgets/tm_app_bar.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  static const String name ='/new-task-list';

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  bool _getTaskCountByStatusInProgress = false;
  bool _getNewTaskListInProgress = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? newTaskListModel;

  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus();
    _getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: ListView(
          children: [
            Visibility(
              visible: _getNewTaskListInProgress == false,
              replacement: const CenteredCircularProgressIndicator(),
              child: Column(
                children: [
                  _buildTaskSummaryByStatus(),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildTaskListView()),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //backgroundColor: AppColors.themeColor,
        onPressed: () {
          Navigator.pushNamed(context, AddNewTaskScreen.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskListView() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: newTaskListModel?.taskList?.length ?? 0,
      itemBuilder: (context, index) {
        return  TaskItemWidget(
          taskModel: newTaskListModel!.taskList![index],
          taskColor: Colors.blue,
          status: 'New',
        );
      },
    );
  }

  Widget _buildTaskSummaryByStatus() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 100,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            primary: false,
            shrinkWrap: true,
            itemCount: taskCountByStatusModel?.taskByStatusList?.length ?? 0,
            itemBuilder: (context, index) {
              final TaskCountModel model =
              taskCountByStatusModel!.taskByStatusList![index];
              return TaskStatusSummaryCounterWidget(
                count: model.sum.toString(), title: model.sId ?? '');
            }),
      ),
    );
  }

  Future<void> _getTaskCountByStatus() async{
    _getTaskCountByStatusInProgress = true;
    setState(() {});
    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.taskCountByStatusUrl);
    if(response.isSuccess){
      taskCountByStatusModel =
          TaskCountByStatusModel.fromJson(response.responseData!);
    }else{
      showSnackBarMessage(context, response.errorMessage);
    }
    _getTaskCountByStatusInProgress = false;
    setState(() {});
  }

  Future<void> _getNewTaskList() async{
    _getNewTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('New'));
    if(response.isSuccess){
      newTaskListModel = TaskListByStatusModel.fromJson(response.responseData!);
    }else{
      showSnackBarMessage(context, response.errorMessage);
    }
    _getNewTaskListInProgress = false;
    setState(() {});
  }
}
