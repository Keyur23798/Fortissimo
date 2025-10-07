/// status : 1
/// message : "Record update successfully."
/// data : {"id":183,"name":"test","email":"aabc@gmail.com","ip_address":"182.69.31.195","api_token":"4a20e5a16b36448d900215bbd5aaff1697e22629a3fa889abf2a888cf56c98e7","device_token":"rfhthfg67","login_type":"Google","profile_pic":"http://testing.virtualqube.in/fortissimo/api/upload/profile/1649399242.jpg","date_of_birth":"1994-12-24","gender":"Female","height":"500","height_unit":"cm","weight":"52","weight_unit":"kg","workout_goal":1,"age":27}

class EditProfileResponse {
  EditProfileResponse({
      this.status, 
      this.message, 
      this.data,});

  EditProfileResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int? status;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

/// id : 183
/// name : "test"
/// email : "aabc@gmail.com"
/// ip_address : "182.69.31.195"
/// api_token : "4a20e5a16b36448d900215bbd5aaff1697e22629a3fa889abf2a888cf56c98e7"
/// device_token : "rfhthfg67"
/// login_type : "Google"
/// profile_pic : "http://testing.virtualqube.in/fortissimo/api/upload/profile/1649399242.jpg"
/// date_of_birth : "1994-12-24"
/// gender : "Female"
/// height : "500"
/// height_unit : "cm"
/// weight : "52"
/// weight_unit : "kg"
/// workout_goal : 1
/// age : 27

class Data {
  Data({
      this.id, 
      this.name, 
      this.email, 
      this.ipAddress, 
      this.apiToken, 
      this.deviceToken, 
      this.loginType, 
      this.profilePic, 
      this.dateOfBirth, 
      this.gender, 
      this.height, 
      this.heightUnit, 
      this.weight, 
      this.profile_pic_url,
      this.weightUnit,
      this.workoutGoal, 
      this.age,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    ipAddress = json['ip_address'];
    apiToken = json['api_token'];
    deviceToken = json['device_token'];
    loginType = json['login_type'];
    profilePic = json['profile_pic'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    height = json['height'];
    heightUnit = json['height_unit'];
    weight = json['weight'];
    profile_pic_url = json['profile_pic_url'];
    weightUnit = json['weight_unit'];
    workoutGoal = json['workout_goal'];
    age = json['age'];
  }
  int? id;
  String? name;
  String? email;
  String? ipAddress;
  String? apiToken;
  String? deviceToken;
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
  int? age;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['ip_address'] = ipAddress;
    map['api_token'] = apiToken;
    map['device_token'] = deviceToken;
    map['login_type'] = loginType;
    map['profile_pic'] = profilePic;
    map['date_of_birth'] = dateOfBirth;
    map['gender'] = gender;
    map['height'] = height;
    map['height_unit'] = heightUnit;
    map['weight'] = weight;
    map['profile_pic_url'] = profile_pic_url;
    map['weight_unit'] = weightUnit;
    map['workout_goal'] = workoutGoal;
    map['age'] = age;
    return map;
  }

}