class OverView {
  int total;
  int current;
  int completed;
  int deleted;

  OverView({this.total, this.current, this.completed, this.deleted});

  factory OverView.fromJson(Map<String, dynamic> map) {
    return OverView(
        total: map["total"],
        current: map["current"],
        completed: map["completed"],
        deleted: map["deleted"]);
  }
}
