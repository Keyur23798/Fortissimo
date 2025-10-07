/// status : 1
/// message : "Success."
/// SET : 9
/// total : "3580"
/// data : [{"workout_name":"Barbbell Bench Press","id":2,"user_id":1,"workout_id":3,"weight":"70","weight_unit":"kg","repititions":4,"calories_burnt":600,"created_at":"2022-02-23T10:37:22.000000Z","updated_at":"2022-02-23T05:12:47.000000Z"},{"workout_name":"Barbbell Bench Press","id":4,"user_id":1,"workout_id":3,"weight":"70","weight_unit":"kg","repititions":4,"calories_burnt":300,"created_at":"2022-03-12T09:41:51.000000Z","updated_at":"2022-03-12T09:41:51.000000Z"},{"workout_name":"Barbbell Bench Press","id":5,"user_id":1,"workout_id":3,"weight":"70","weight_unit":"kg","repititions":4,"calories_burnt":300,"created_at":"2022-03-22T06:54:16.000000Z","updated_at":"2022-03-22T06:54:16.000000Z"},{"workout_name":"Barbbell Bench Press","id":51,"user_id":1,"workout_id":3,"weight":"50","weight_unit":"kg","repititions":2,"calories_burnt":400,"created_at":"2022-03-28T11:54:40.000000Z","updated_at":"2022-03-28T11:54:40.000000Z"},{"workout_name":"Barbbell Bench Press","id":52,"user_id":1,"workout_id":3,"weight":"20","weight_unit":"kg","repititions":1,"calories_burnt":200,"created_at":"2022-03-28T11:54:40.000000Z","updated_at":"2022-03-29T10:46:23.000000Z"},{"workout_name":"Barbbell Bench Press","id":53,"user_id":1,"workout_id":3,"weight":"40","weight_unit":"kg","repititions":3,"calories_burnt":200,"created_at":"2022-03-28T11:54:40.000000Z","updated_at":"2022-03-29T10:46:11.000000Z"},{"workout_name":"Barbbell Bench Press","id":54,"user_id":1,"workout_id":3,"weight":"50","weight_unit":"kg","repititions":2,"calories_burnt":500,"created_at":"2022-03-28T11:56:51.000000Z","updated_at":"2022-03-28T11:57:21.000000Z"},{"workout_name":"Barbbell Bench Press","id":55,"user_id":1,"workout_id":3,"weight":"20","weight_unit":"kg","repititions":1,"calories_burnt":1000,"created_at":"2022-03-28T11:56:51.000000Z","updated_at":"2022-03-29T10:46:16.000000Z"},{"workout_name":"Barbbell Bench Press","id":56,"user_id":1,"workout_id":3,"weight":"40","weight_unit":"kg","repititions":3,"calories_burnt":80,"created_at":"2022-03-28T11:56:51.000000Z","updated_at":"2022-03-29T10:46:20.000000Z"}]

class UserWorkoutActivityListResponse {
  UserWorkoutActivityListResponse({
      this.status, 
      this.message, 
      this.set, 
      this.total, 
      this.data,});

  UserWorkoutActivityListResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    set = json['SET'];
    total = json['total'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  int? status;
  String? message;
  int? set;
  int? total;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['SET'] = set;
    map['total'] = total;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// workout_name : "Barbbell Bench Press"
/// id : 2
/// user_id : 1
/// workout_id : 3
/// weight : "70"
/// weight_unit : "kg"
/// repititions : 4
/// calories_burnt : 600
/// created_at : "2022-02-23T10:37:22.000000Z"
/// updated_at : "2022-02-23T05:12:47.000000Z"

class Data {
  Data({
      this.workoutName, 
      this.id, 
      this.userId, 
      this.workoutId, 
      this.weight, 
      this.weightUnit, 
      this.repititions, 
      this.caloriesBurnt, 
      this.createdAt, 
      this.updatedAt,});

  Data.fromJson(dynamic json) {
    workoutName = json['workout_name'];
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
  String? workoutName;
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
    map['workout_name'] = workoutName;
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