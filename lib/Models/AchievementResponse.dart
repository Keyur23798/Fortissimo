/// status : 1
/// message : "Success."
/// WeekWiseAchievements : [{"calories_burnt":46,"day":"Mon"},{"calories_burnt":37,"day":"Tues"}]
/// MonthWiseAchievements : [{"calories_burnt":"244","date":"08"},{"calories_burnt":"3936","date":"11"},{"calories_burnt":"20","date":"12"},{"calories_burnt":"87","date":"15"},{"calories_burnt":"46","date":"18"},{"calories_burnt":"37","date":"19"}]
/// YearWiseAchievements : [{"calories_burnt":"4370","monthname":"April"}]

class AchievementResponse {
  AchievementResponse({
      this.status, 
      this.message, 
      this.weekWiseAchievements, 
      this.monthWiseAchievements, 
      this.yearWiseAchievements,});

  AchievementResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['WeekWiseAchievements'] != null) {
      weekWiseAchievements = [];
      json['WeekWiseAchievements'].forEach((v) {
        weekWiseAchievements?.add(WeekWiseAchievements.fromJson(v));
      });
    }
    if (json['MonthWiseAchievements'] != null) {
      monthWiseAchievements = [];
      json['MonthWiseAchievements'].forEach((v) {
        monthWiseAchievements?.add(MonthWiseAchievements.fromJson(v));
      });
    }
    if (json['YearWiseAchievements'] != null) {
      yearWiseAchievements = [];
      json['YearWiseAchievements'].forEach((v) {
        yearWiseAchievements?.add(YearWiseAchievements.fromJson(v));
      });
    }
  }
  int? status;
  String? message;
  List<WeekWiseAchievements>? weekWiseAchievements;
  List<MonthWiseAchievements>? monthWiseAchievements;
  List<YearWiseAchievements>? yearWiseAchievements;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (weekWiseAchievements != null) {
      map['WeekWiseAchievements'] = weekWiseAchievements?.map((v) => v.toJson()).toList();
    }
    if (monthWiseAchievements != null) {
      map['MonthWiseAchievements'] = monthWiseAchievements?.map((v) => v.toJson()).toList();
    }
    if (yearWiseAchievements != null) {
      map['YearWiseAchievements'] = yearWiseAchievements?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// calories_burnt : "4370"
/// monthname : "April"

class YearWiseAchievements {
  YearWiseAchievements({
      this.caloriesBurnt, 
      this.monthname,});

  YearWiseAchievements.fromJson(dynamic json) {
    caloriesBurnt = json['calories_burnt'];
    monthname = json['monthname'];
  }
  String? caloriesBurnt;
  String? monthname;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['calories_burnt'] = caloriesBurnt;
    map['monthname'] = monthname;
    return map;
  }

}

/// calories_burnt : "244"
/// date : "08"

class MonthWiseAchievements {
  MonthWiseAchievements({
      this.caloriesBurnt, 
      this.date,});

  MonthWiseAchievements.fromJson(dynamic json) {
    caloriesBurnt = json['calories_burnt'];
    date = json['date'];
  }
  String? caloriesBurnt;
  String? date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['calories_burnt'] = caloriesBurnt;
    map['date'] = date;
    return map;
  }

}

/// calories_burnt : 46
/// day : "Mon"

class WeekWiseAchievements {
  WeekWiseAchievements({
      this.caloriesBurnt, 
      this.day,});

  WeekWiseAchievements.fromJson(dynamic json) {
    caloriesBurnt = json['calories_burnt'];
    day = json['day'];
  }
  String? caloriesBurnt;
  String? day;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['calories_burnt'] = caloriesBurnt;
    map['day'] = day;
    return map;
  }

}