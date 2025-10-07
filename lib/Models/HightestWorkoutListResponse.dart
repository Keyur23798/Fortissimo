/// status : 1
/// message : "Success."
/// base_url : "http://testing.virtualqube.in/fortissimo/api"
/// data : [{"workout_id":3,"workout_name":"Barbbell Bench Press","workout_icon":"upload/workouts/wicon1648617936.png","calories_burnt":1000,"weight":"70"},{"workout_id":1,"workout_name":"Standing Dumbbell Press","workout_icon":"upload/workouts/wicon1648618209.png","calories_burnt":500,"weight":"60"}]

class HightestWorkoutListResponse {
  HightestWorkoutListResponse({
      this.status, 
      this.message, 
      this.baseUrl, 
      this.data,});

  HightestWorkoutListResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    baseUrl = json['base_url'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  int? status;
  String? message;
  String? baseUrl;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['base_url'] = baseUrl;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// workout_id : 3
/// workout_name : "Barbbell Bench Press"
/// workout_icon : "upload/workouts/wicon1648617936.png"
/// calories_burnt : 1000
/// weight : "70"

class Data {
  Data({
      this.workoutId, 
      this.workoutName, 
      this.workoutIcon, 
      this.caloriesBurnt, 
      this.weight,});

  Data.fromJson(dynamic json) {
    workoutId = json['workout_id'];
    workoutName = json['workout_name'];
    workoutIcon = json['workout_icon'];
    caloriesBurnt = json['calories_burnt'];
    weight = json['weight'];
  }
  int? workoutId;
  String? workoutName;
  String? workoutIcon;
  int? caloriesBurnt;
  int? weight;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['workout_id'] = workoutId;
    map['workout_name'] = workoutName;
    map['workout_icon'] = workoutIcon;
    map['calories_burnt'] = caloriesBurnt;
    map['weight'] = weight;
    return map;
  }

}