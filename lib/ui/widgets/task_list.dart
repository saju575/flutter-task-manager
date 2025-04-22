import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/empty_placeholder.dart';
import 'package:task_manager/ui/widgets/spiner.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class TaskList extends StatefulWidget {
  final String status;
  final String? errorMessage;
  final String? emptyDataMessage;

  const TaskList({
    super.key,
    required this.status,
    this.errorMessage,
    this.emptyDataMessage,
  });

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late List<TaskModel> _taskListData = [];
  late bool _isFetchingTaskList = false;
  late bool _isError = false;
  late bool _isInitialFetch = false;

  @override
  void initState() {
    super.initState();
    _initialFetchTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTaskList();
  }

  Widget _buildTaskList() {
    TextTheme textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: _refreshTaskList,
      child: _buildTaskListContent(textTheme),
    );
  }

  Widget _buildTaskListContent(TextTheme textTheme) {
    if (_isInitialFetch && _isFetchingTaskList) {
      return Center(child: Spinner(size: 24, color: AppColors.primaryColor));
    } else if (_isError) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: EmptyPlaceholder(
              message: widget.errorMessage ?? "Error fetching task list",
            ),
          ),
        ],
      );
    } else if (_taskListData.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: EmptyPlaceholder(
                message: widget.emptyDataMessage ?? "No data found",
              ),
            ),
          ),
        ],
      );
    } else {
      return _taskList(textTheme);
    }
  }

  Widget _taskList(TextTheme textTheme) {
    return ListView.separated(
      itemBuilder: (context, index) => TaskCard(task: _taskListData[index]),
      separatorBuilder: (context, index) => SizedBox(height: 9),
      itemCount: _taskListData.length,
    );
  }

  Future<void> _initialFetchTaskList() async {
    setState(() {
      _isError = false;
      _isInitialFetch = true;
      _isFetchingTaskList = true;
    });
    await _getTaskList();
    setState(() {
      _isFetchingTaskList = false;
      _isInitialFetch = false;
    });
  }

  Future<void> _getTaskList() async {
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.getLaskListByStatus(widget.status),
      token: true,
    );
    if (response.isSuccess) {
      _taskListData = TaskListModel.fromJson(response.data).data;
    } else {
      _isError = true;
    }
  }

  Future<void> _refreshTaskList() async {
    setState(() {
      _isError = false;
    });
    await _getTaskList();
    setState(() {});
  }
}
