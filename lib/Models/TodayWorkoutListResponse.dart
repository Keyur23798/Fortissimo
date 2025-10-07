/// status : 1
/// message : "Success."
/// base_url : "http://testing.virtualqube.in/fortissimo/api/"
/// data : [{"workout_id":1,"workout_name":"Standing Dumbbell Press","workout_icon":"upload/workouts/wicon1648618209.png","calories_burnt":"4280","workout":[{"id":57,"user_id":1,"workout_id":1,"weight":"50","weight_unit":"kg","repititions":2,"calories_burnt":200,"created_at":"2022-03-30T11:54:19.000000Z","updated_at":"2022-03-30T11:54:19.000000Z"},{"id":58,"user_id":1,"workout_id":1,"weight":"20","weight_unit":"kg","repititions":1,"calories_burnt":2000,"created_at":"2022-03-30T11:54:19.000000Z","updated_at":"2022-03-30T11:54:19.000000Z"},{"id":59,"user_id":1,"workout_id":1,"weight":"40","weight_unit":"kg","repititions":3,"calories_burnt":2080,"created_at":"2022-03-30T11:54:19.000000Z","updated_at":"2022-03-30T11:54:19.000000Z"}]}]

class TodayWorkoutListResponse {
  TodayWorkoutListResponse({
      this.status, 
      this.message, 
      this.baseUrl, 
      this.data,});

  TodayWorkoutListResponse.fromJson(dynamic json) {
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

/// workout_id : 1
/// workout_name : "Standing Dumbbell Press"
/// workout_icon : "upload/workouts/wicon1648618209.png"
/// calories_burnt : "4280"
/// workout : [{"id":57,"user_id":1,"workout_id":1,"weight":"50","weight_unit":"kg","repititions":2,"calories_burnt":200,"created_at":"2022-03-30T11:54:19.000000Z","updated_at":"2022-03-30T11:54:19.000000Z"},{"id":58,"user_id":1,"workout_id":1,"weight":"20","weight_unit":"kg","repititions":1,"calories_burnt":2000,"created_at":"2022-03-30T11:54:19.000000Z","updated_at":"2022-03-30T11:54:19.000000Z"},{"id":59,"user_id":1,"workout_id":1,"weight":"40","weight_unit":"kg","repititions":3,"calories_burnt":2080,"created_at":"2022-03-30T11:54:19.000000Z","updated_at":"2022-03-30T11:54:19.000000Z"}]

class Data {
  Data({
      this.workoutId, 
      this.workoutName, 
      this.workoutIcon, 
      this.caloriesBurnt, 
      this.workout,});

  Data.fromJson(dynamic json) {
    workoutId = json['workout_id'];
    workoutName = json['workout_name'];
    workoutIcon = json['workout_icon'];
    caloriesBurnt = json['calories_burnt'];
    if (json['workout'] != null) {
      workout = [];
      json['workout'].forEach((v) {
        workout?.add(Workout.fromJson(v));
      });
    }
  }
  int? workoutId;
  String? workoutName;
  String? workoutIcon;
  String? caloriesBurnt;
  List<Workout>? workout;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['workout_id'] = workoutId;
    map['workout_name'] = workoutName;
    map['workout_icon'] = workoutIcon;
    map['calories_burnt'] = caloriesBurnt;
    if (workout != null) {
      map['workout'] = workout?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 57
/// user_id : 1
/// workout_id : 1
/// weight : "50"
/// weight_unit : "kg"
/// repititions : 2
/// calories_burnt : 200
/// created_at : "2022-03-30T11:54:19.000000Z"
/// updated_at : "2022-03-30T11:54:19.000000Z"

class Workout {
  Workout({
      this.id, 
      this.userId, 
      this.workoutId, 
      this.weight, 
      this.weightUnit, 
      this.repititions, 
      this.caloriesBurnt, 
      this.createdAt, 
      this.updatedAt,});

  Workout.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    workoutId = json['workout_id'];
    weight = json['weight'];
    weightUnit = json['weight_unit'];
    repititions = json['repititions'];
    caloriesBurnt = json['calories_burnt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  int? userId;
  int? workoutId;
  int? weight;
  String? weightUnit;
  int? repititions;
  int? caloriesBurnt;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['workout_id'] = workoutId;
    map['weight'] = weight;
    map['weight_unit'] = weightUnit;
    map['repititions'] = repititions;
    map['calories_burnt'] = caloriesBurnt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}