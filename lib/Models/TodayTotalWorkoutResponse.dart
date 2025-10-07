/// status : 1
/// message : "Success."
/// TodayTotalWorkout : "4280"

class TodayTotalWorkoutResponse {
  TodayTotalWorkoutResponse({
      this.status, 
      this.message, 
      this.todayTotalWorkout,});

  TodayTotalWorkoutResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    todayTotalWorkout = json['TodayTotalWorkout'];
  }
  int? status;
  String? message;
  int? todayTotalWorkout;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['TodayTotalWorkout'] = todayTotalWorkout;
    return map;
  }

}