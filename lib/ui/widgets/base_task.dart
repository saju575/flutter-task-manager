import 'package:flutter/material.dart';
import 'package:task_manager/ui/app.dart';

abstract class BaseTask extends StatefulWidget {
  const BaseTask({super.key});
}

abstract class BaseTaskState<T extends BaseTask> extends State<T>
    with RouteAware {
  Future<void> onRefreshOnReturn();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    onRefreshOnReturn();
  }
}
