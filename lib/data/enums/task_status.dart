enum TaskStatus {
  completed("Completed"),
  progress("Progress"),
  canceled("Canceled"),
  newTask("New");

  final String label;

  const TaskStatus(this.label);
}
