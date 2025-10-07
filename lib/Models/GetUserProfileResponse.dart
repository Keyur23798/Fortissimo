class GetUserProfileResponse {
  int? status;
  String? message;
  List<Data>? data;

  GetUserProfileResponse({
    this.status,
    this.message,
    this.data});

  GetUserProfileResponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (data != null) {
      map["data"] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  String? name;
  String? email;
  String? ipAddress;
  int? isActive;
  String? loginType;
  String? profilePic;
  String? dateOfBirth;
  String? gender;
  String? height;
  String? heightUnit;
  String? weight;
  String? profile_pic_url;
  String? weightUnit;
  int? workoutGoal;
  String? createdAt;
  String? updatedAt;

  Data({
    this.name,
    this.email,
    this.ipAddress,
    this.isActive,
    this.loginType,
    this.profilePic,
    this.dateOfBirth,
    this.gender,
    this.height,
    this.heightUnit,
    this.weight,
    this.weightUnit,
    this.profile_pic_url,
    this.workoutGoal,
    this.createdAt,
    this.updatedAt});

  Data.fromJson(dynamic json) {
    name = json["name"];
    email = json["email"];
    ipAddress = json["ip_address"];
    isActive = json["isActive"];
    loginType = json["login_type"];
    profilePic = json["profile_pic"];
    dateOfBirth = json["date_of_birth"];
    gender = json["gender"];
    height = json["height"];
    heightUnit = json["height_unit"];
    weight = json["weight"];
    profile_pic_url = json["profile_pic_url"];
    weightUnit = json["weight_unit"];
    workoutGoal = json["workout_goal"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["email"] = email;
    map["ip_address"] = ipAddress;
    map["isActive"] = isActive;
    map["login_type"] = loginType;
    map["profile_pic"] = profilePic;
    map["date_of_birth"] = dateOfBirth;
    map["gender"] = gender;
    map["height"] = height;
    map["height_unit"] = heightUnit;
    map["weight"] = weight;
    map["profile_pic_url"] = profile_pic_url;
    map["weight_unit"] = weightUnit;
    map["workout_goal"] = workoutGoal;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    return map;
  }

}