/// status : 1
/// message : "Success."
/// data : [{"notification_id":1,"user_id":0,"title":"test title","message":"test message","created_at":"2022-04-08 11:19:22"}]

class Notificationresponse {
  Notificationresponse({
      this.status, 
      this.message, 
      this.data,});

  Notificationresponse.fromJson(dynamic json) {
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

/// notification_id : 1
/// user_id : 0
/// title : "test title"
/// message : "test message"
/// created_at : "2022-04-08 11:19:22"

class Data {
  Data({
      this.notificationId, 
      this.userId, 
      this.title, 
      this.message, 
      this.createdAt,});

  Data.fromJson(dynamic json) {
    notificationId = json['notification_id'];
    userId = json['user_id'];
    title = json['title'];
    message = json['message'];
    createdAt = json['created_at'];
  }
  int? notificationId;
  int? userId;
  String? title;
  String? message;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['notification_id'] = notificationId;
    map['user_id'] = userId;
    map['title'] = title;
    map['message'] = message;
    map['created_at'] = createdAt;
    return map;
  }

}