class AddWorkoutResponse {
  int? status;
  String? message;

  AddWorkoutResponse({
    this.status,
    this.message});

  AddWorkoutResponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    return map;
  }

}