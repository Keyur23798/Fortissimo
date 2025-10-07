/// status : 1
/// message : "Success."
/// base_url : "http://testing.virtualqube.in/fortissimo/api/"
/// data : [{"muscle_name":"Biceps","workout_id":1,"muscle_id":2,"workout_name":"Standing Dumbbell Press","workout_image":"upload/workouts/wi1648618199Standing Dumbbell Press.png","workout_description":"<p>lorem ipsum</p>","equipment_name":"rrddd","equipment_image":"upload/workouts/eq1645016001dsfsdfsd.png","workout_icon":"upload/workouts/wicon1648618209.png","MET":0,"met_light":"5.00","met_heavy":"0.13","isActive":0,"created_at":"2022-02-14T08:28:43.000000Z","updated_at":"2022-03-30T05:30:09.000000Z"},{"muscle_name":"Arms","workout_id":3,"muscle_id":1,"workout_name":"Barbbell Bench Press","workout_image":"upload/workouts/wi1648618156Barbbell Bench Press.png","workout_description":"<p><em>Lorem Ipsum</em>&nbsp;is simply&nbsp;<em>dummy text</em>&nbsp;of the printing and typesetting industry.&nbsp;</p>","equipment_name":"rrddd","equipment_image":"upload/workouts/eq1645018514dsfsdfaa.jpg","workout_icon":"upload/workouts/wicon1648617936.png","MET":0,"met_light":"0.02","met_heavy":"1.00","isActive":0,"created_at":"2022-02-16T08:03:12.000000Z","updated_at":"2022-03-30T05:29:16.000000Z"},{"muscle_name":"Shoulders","workout_id":4,"muscle_id":5,"workout_name":"Barbbell Bench","workout_image":"upload/workouts/1645594207Barbbell Bench Press.jpg","workout_description":"<p><em>Lorem Ipsum</em> is simpl</p>","equipment_name":"rrddd","equipment_image":"upload/workouts/eq1645018514dsfsdfaa.jpg","workout_icon":"upload/workouts/wicon1648559241.png","MET":0,"met_light":"0.02","met_heavy":"0.02","isActive":0,"created_at":"2022-02-16T08:03:12.000000Z","updated_at":"2022-03-29T13:55:54.000000Z"},{"muscle_name":"Biceps","workout_id":18,"muscle_id":2,"workout_name":"Barbbell Benchaa","workout_image":"upload/workouts/1648127732Barbbell Benchaa.png","workout_description":"<p>ee</p>","equipment_name":"rrddd","equipment_image":"upload/workouts/eq1645018514dsfsdfaa.jpg","workout_icon":"upload/workouts/wicon1648557439.jpg","MET":1,"met_light":"2.00","met_heavy":"3.00","isActive":0,"created_at":"2022-03-24T13:15:32.000000Z","updated_at":"2022-03-29T13:27:48.000000Z"}]

class WorkoutListResponse {
  WorkoutListResponse({
      this.status, 
      this.message, 
      this.baseUrl, 
      this.data,});

  WorkoutListResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    baseUrl = json['base_url'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(WorkoutList.fromJson(v));
      });
    }
  }
  int? status;
  String? message;
  String? baseUrl;
  List<WorkoutList>? data;

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

/// muscle_name : "Biceps"
/// workout_id : 1
/// muscle_id : 2
/// workout_name : "Standing Dumbbell Press"
/// workout_image : "upload/workouts/wi1648618199Standing Dumbbell Press.png"
/// workout_description : "<p>lorem ipsum</p>"
/// equipment_name : "rrddd"
/// equipment_image : "upload/workouts/eq1645016001dsfsdfsd.png"
/// workout_icon : "upload/workouts/wicon1648618209.png"
/// MET : 0
/// met_light : "5.00"
/// met_heavy : "0.13"
/// isActive : 0
/// created_at : "2022-02-14T08:28:43.000000Z"
/// updated_at : "2022-03-30T05:30:09.000000Z"

class WorkoutList {
  WorkoutList({
      this.muscleName, 
      this.workoutId, 
      this.muscleId, 
      this.workoutName, 
      this.workoutImage, 
      this.workoutDescription, 
      this.equipmentName, 
      this.equipmentImage, 
      this.workoutIcon, 
      this.met, 
      this.metLight, 
      this.metHeavy, 
      this.isActive, 
      this.createdAt, 
      this.updatedAt,});

  WorkoutList.fromJson(dynamic json) {
    muscleName = json['muscle_name'];
    workoutId = json['workout_id'];
    muscleId = json['muscle_id'];
    workoutName = json['workout_name'];
    workoutImage = json['workout_image'];
    workoutDescription = json['workout_description'];
    equipmentName = json['equipment_name'];
    equipmentImage = json['equipment_image'];
    workoutIcon = json['workout_icon'];
    met = json['MET'];
    metLight = json['met_light'];
    metHeavy = json['met_heavy'];
    isActive = json['isActive'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  String? muscleName;
  int? workoutId;
  int? muscleId;
  String? workoutName;
  String? workoutImage;
  String? workoutDescription;
  String? equipmentName;
  String? equipmentImage;
  String? workoutIcon;
  int? met;
  String? metLight;
  String? metHeavy;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['muscle_name'] = muscleName;
    map['workout_id'] = workoutId;
    map['muscle_id'] = muscleId;
    map['workout_name'] = workoutName;
    map['workout_image'] = workoutImage;
    map['workout_description'] = workoutDescription;
    map['equipment_name'] = equipmentName;
    map['equipment_image'] = equipmentImage;
    map['workout_icon'] = workoutIcon;
    map['MET'] = met;
    map['met_light'] = metLight;
    map['met_heavy'] = metHeavy;
    map['isActive'] = isActive;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}