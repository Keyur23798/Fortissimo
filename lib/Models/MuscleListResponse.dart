/// status : 1
/// message : "Success."
/// data : [{"muscle_id":0,"muscle_name":"All","isActive":0,"created_at":"","updated_at":""},{"muscle_id":1,"muscle_name":"Arms","isActive":0,"created_at":"2022-02-11T09:12:51.000000Z","updated_at":"2022-02-18T09:29:20.000000Z"},{"muscle_id":2,"muscle_name":"Biceps","isActive":0,"created_at":"2022-02-11T09:12:56.000000Z","updated_at":"2022-02-18T09:29:16.000000Z"},{"muscle_id":3,"muscle_name":"Chest","isActive":0,"created_at":"2022-02-11T09:13:01.000000Z","updated_at":"2022-02-11T09:13:01.000000Z"},{"muscle_id":4,"muscle_name":"Legs","isActive":0,"created_at":"2022-02-11T09:13:03.000000Z","updated_at":"2022-02-11T09:13:03.000000Z"},{"muscle_id":5,"muscle_name":"Shoulders","isActive":0,"created_at":"2022-02-11T09:13:05.000000Z","updated_at":"2022-02-11T09:13:05.000000Z"}]

class MuscleListResponse {
  MuscleListResponse({
      this.status, 
      this.message, 
      this.data,});

  MuscleListResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  int? status;
  String? message;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// muscle_id : 0
/// muscle_name : "All"
/// isActive : 0
/// created_at : ""
/// updated_at : ""

class Data {
  Data({
      this.muscleId, 
      this.muscleName, 
      this.isActive, 
      this.createdAt, 
      this.updatedAt,});

  Data.fromJson(dynamic json) {
    muscleId = json['muscle_id'];
    muscleName = json['muscle_name'];
    isActive = json['isActive'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? muscleId;
  String? muscleName;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  bool? isSelected;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['muscle_id'] = muscleId;
    map['muscle_name'] = muscleName;
    map['isActive'] = isActive;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}