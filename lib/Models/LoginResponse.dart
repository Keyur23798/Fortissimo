class LoginResponse {
  int? status;
  String? message;
  String? baseUrl;
  List<Data>? data;

  LoginResponse({
    this.status,
    this.message,
    this.baseUrl,
    this.data});

  LoginResponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    baseUrl = json["base_url"];
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
    map["base_url"] = baseUrl;
    if (data != null) {
      map["data"] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  int? id;
  String? name;
  String? email;
  String? apiToken;
  String? deviceToken;
  String? ipAddress;
  String? loginType;
  String? profilePic;
  String? dateOfBirth;
  String? gender;
  String? height;
  String? heightUnit;
  String? weight;
  String? weightUnit;
  String? profile_pic_url;
  int? age;
  int? workoutGoal;

  Data({
    this.id,
    this.name,
    this.email,
    this.apiToken,
    this.deviceToken,
    this.ipAddress,
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
    this.age});

  Data.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    apiToken = json["api_token"];
    deviceToken = json["device_token"];
    ipAddress = json["ip_address"];
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
    age = json["age"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["email"] = email;
    map["api_token"] = apiToken;
    map["device_token"] = deviceToken;
    map["ip_address"] = ipAddress;
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
    map["age"] = age;
    return map;
  }

}