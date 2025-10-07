import 'dart:convert';
import 'package:fortissimo/Models/AchievementResponse.dart';
import 'package:fortissimo/Models/AddWorkoutResponse.dart';
import 'package:fortissimo/Models/CompanyProfileResponse.dart';
import 'package:fortissimo/Models/DeleteActivityResponse.dart';
import 'package:fortissimo/Models/EditProfileResponse.dart';
import 'package:fortissimo/Models/GetUserProfileResponse.dart';
import 'package:fortissimo/Models/HightestWorkoutListResponse.dart';
import 'package:fortissimo/Models/LoginResponse.dart';
import 'package:fortissimo/Models/MuscleListResponse.dart';
import 'package:fortissimo/Models/Notificationresponse.dart';
import 'package:fortissimo/Models/RegisterResponse.dart';
import 'package:fortissimo/Models/RepeatWorkoutListResponse.dart';
import 'package:fortissimo/Models/TodayTotalWorkoutResponse.dart';
import 'package:fortissimo/Models/TodayWorkoutListResponse.dart';
import 'package:fortissimo/Models/UserWorkoutActivityListResponse.dart';
import 'package:fortissimo/Models/WorkoutListResponse.dart';
import 'package:fortissimo/Models/WorkoutDetailResponse.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  String baseUrlAuth = 'http://testing.virtualqube.in/fortissimo/api/oauth/';
  String baseUrl = 'http://testing.virtualqube.in/fortissimo/api/';

  Future<LoginResponse> login(String email, String type, String token) async {
    String url = baseUrlAuth + 'login';
    Uri uri = Uri.parse(url);
    Response response = await post(uri, headers: {
      'apikey': 'Mobile',
    }, body: {
      'email': email,
      'login_type': type,
      'device_token': token,
    });

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return LoginResponse();
  }

  Future<RegisterResponse> register(
      String name,
      String email,
      String device_token,
      String login_type,
      String gender,
      String height,
      String height_unit,
      String dob,
      String weight,
      String weight_unit,
      String file,
      String workOutGoal,
      String profilePicUrl) async {
    String url = baseUrlAuth + 'register';
    Uri uri = Uri.parse(url);

    Map<String, String> headers = {"apikey": "Mobile"};
    var request = MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    if (file != '') {
      request.files.add(await MultipartFile.fromPath('profile_pic', file));
    }

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['device_token'] = device_token;
    request.fields['login_type'] = login_type;
    request.fields['gender'] = gender;
    request.fields['height'] = height;
    request.fields['height_unit'] = height_unit;
    request.fields['date_of_birth'] = dob;
    request.fields['weight'] = weight;
    request.fields['weight_unit'] = weight_unit;
    request.fields['workout_goal'] = workOutGoal;
    request.fields['profile_pic_url'] = profilePicUrl;

    var streamedResponse = await request.send();
    var response = await Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return RegisterResponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return RegisterResponse();
  }

  Future<EditProfileResponse> editProfile(
      String userid,
      String profilePic,
      String gender,
      String dob,
      String height,
      String height_unit,
      String weight,
      String weight_unit,
      String workout_goal,
      String profilePicUrl) async {
    String url = baseUrl + 'edit-userdetails';
    Uri uri = Uri.parse(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('apiToken');
    Map<String, String> headers = {"apikey": "Mobile", 'Authorization': token!};
    var request = MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    if (profilePic != '') {
      request.files
          .add(await MultipartFile.fromPath('profile_pic', profilePic));
    }

    request.fields['user_id'] = userid;
    request.fields['gender'] = gender;
    request.fields['date_of_birth'] = dob;
    request.fields['height'] = height;
    request.fields['height_unit'] = height_unit;
    request.fields['weight'] = weight;
    request.fields['weight_unit'] = weight_unit;
    request.fields['workout_goal'] = workout_goal;
    request.fields['profile_pic_url'] = profilePicUrl;

    var streamedResponse = await request.send();
    var response = await Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return EditProfileResponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return EditProfileResponse();
  }

  Future<CompanyProfileResponse> companyProfile() async {
    String url = baseUrlAuth + 'companyprofile';
    Uri uri = Uri.parse(url);
    Response response = await get(
      uri,
      headers: {
        'apikey': 'Mobile',
      },
    );

    if (response.statusCode == 200) {
      return CompanyProfileResponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return CompanyProfileResponse();
  }

  Future<GetUserProfileResponse> getProfile(String userId) async {
    String url = baseUrl + 'getUserProfile';
    Uri uri = Uri.parse(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('apiToken');
    Response response = await post(uri, headers: {
      'apikey': 'Mobile',
      'Authorization': token!
    }, body: {
      'user_id': userId,
    });

    if (response.statusCode == 200) {
      return GetUserProfileResponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return GetUserProfileResponse();
  }

  Future<MuscleListResponse> getMuscleList() async {
    String url = 'http://testing.virtualqube.in/fortissimo/api/muscle-list';
    Uri uri = Uri.parse(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('apiToken');
    Response response = await get(
      uri,
      headers: {'apikey': 'Mobile', 'Authorization': token!},
    );

    if (response.statusCode == 200) {
      return MuscleListResponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return MuscleListResponse();
  }

  Future<WorkoutListResponse> workoutList(String muscleId) async {
    String url = baseUrl + 'mascleIDwise-workoutList';
    Uri uri = Uri.parse(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('apiToken');
    Response response = await post(uri, headers: {
      'apikey': 'Mobile',
      'Authorization': token!
    }, body: {
      'muscle_id': muscleId,
    });

    if (response.statusCode == 200) {
      return WorkoutListResponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return WorkoutListResponse();
  }

  Future<WorkoutListResponse> searchWorkout(String text) async {
    String url = baseUrl + 'search-exercises';
    Uri uri = Uri.parse(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('apiToken');
    Response response = await post(uri, headers: {
      'apikey': 'Mobile',
      'Authorization': token!
    }, body: {
      'serchvar': text,
    });

    if (response.statusCode == 200) {
      return WorkoutListResponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return WorkoutListResponse();
  }

  Future<AchievementResponse> getAhievement(String userId) async {
    String url = baseUrl + 'user-achievements';
    Uri uri = Uri.parse(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('apiToken');
    Response response = await post(uri, headers: {
      'apikey': 'Mobile',
      'Authorization': token!
    }, body: {
      'user_id': userId,
    });

    if (response.statusCode == 200) {
      return AchievementResponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return AchievementResponse();
  }

  Future<Notificationresponse> getNotification() async {
    String url = baseUrl + 'get_notificationList';
    Uri uri = Uri.parse(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('apiToken');
    Response response = await get(uri, headers: {
      'apikey': 'Mobile',
      'Authorization': token!
    },);

    if (response.statusCode == 200) {
      return Notificationresponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return Notificationresponse();
  }

  Future<WorkoutDetailResponse> workoutDetails(String workoutId) async {
    String url = baseUrl + 'workoutIdWise-Details';
    Uri uri = Uri.parse(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('apiToken');
    Response response = await post(uri, headers: {
      'apikey': 'Mobile',
      'Authorization': token!
    }, body: {
      'workout_id': workoutId,
    });

    if (response.statusCode == 200) {
      return WorkoutDetailResponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return WorkoutDetailResponse();
  }

  Future<AddWorkoutResponse> addWorkout(
      List<Map<String, dynamic>> addWorkout) async {
    String url = baseUrl + 'add-workoutActivities';
    Uri uri = Uri.parse(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('apiToken');
    Response response = await post(uri,
        headers: {
          'apikey': 'Mobile',
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode(addWorkout));

    print("result" + response.body);

    if (response.statusCode == 200) {
      return AddWorkoutResponse.fromJson(json.decode(response.body));
    } else {
      print(response.body.toString());
      print(response.statusCode);
    }
    return AddWorkoutResponse();
  }

  Future<TodayTotalWorkoutResponse> todayTotalWorkout(String userId) async {
    String url = baseUrl + 'today-totalworkoutList';
    Uri uri = Uri.parse(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('apiToken');
    Response response = await post(uri, headers: {
      'apikey': 'Mobile',
      'Authorization': token!
    }, body: {
      'user_id': userId,
    });

    if (response.statusCode == 200) {
      return TodayTotalWorkoutResponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return TodayTotalWorkoutResponse();
  }

  Future<TodayWorkoutListResponse> todayWorkout(String userId) async {
    String url = baseUrl + 'today-workoutList';
    Uri uri = Uri.parse(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('apiToken');
    Response response = await post(uri, headers: {
      'apikey': 'Mobile',
      'Authorization': token!
    }, body: {
      'user_id': userId,
    });

    if (response.statusCode == 200) {
      return TodayWorkoutListResponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return TodayWorkoutListResponse();
  }

  Future<DeleteActivityResponse> deleteWorkout(String userId,String workoutId) async {
    String url = baseUrl + 'deleteWorkoutActivities';
    Uri uri = Uri.parse(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('apiToken');
    Response response = await post(uri, headers: {
      'apikey': 'Mobile',
      'Authorization': token!
    }, body: {
      'user_id': userId,
      'workout_id': workoutId,
    });

    if (response.statusCode == 200) {
      return DeleteActivityResponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return DeleteActivityResponse();
  }

  Future<HightestWorkoutListResponse> highestWorkout(String userId) async {
    String url = baseUrl + 'getHighestWorkout';
    Uri uri = Uri.parse(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('apiToken');
    Response response = await post(uri, headers: {
      'apikey': 'Mobile',
      'Authorization': token!
    }, body: {
      'user_id': userId,
    });

    if (response.statusCode == 200) {
      return HightestWorkoutListResponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return HightestWorkoutListResponse();
  }

  Future<RepeatWorkoutListResponse> repeatWorkoutList(String userId) async {
    String url = baseUrl + 'getRepeatActivity';
    Uri uri = Uri.parse(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('apiToken');
    Response response = await post(uri, headers: {
      'apikey': 'Mobile',
      'Authorization': token!
    }, body: {
      'user_id': userId,
    });

    if (response.statusCode == 200) {
      return RepeatWorkoutListResponse.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return RepeatWorkoutListResponse();
  }

  Future<UserWorkoutActivityListResponse> workoutActivityList(
      String userId, String workoutId) async {
    String url = baseUrl + 'userWorkoutActivitiesList';
    Uri uri = Uri.parse(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('apiToken');
    Response response = await post(uri, headers: {
      'apikey': 'Mobile',
      'Authorization': token!
    }, body: {
      'user_id': userId,
      'workout_id': workoutId,
    });

    if (response.statusCode == 200) {
      return UserWorkoutActivityListResponse.fromJson(
          json.decode(response.body));
    } else {
      print(response.statusCode);
    }
    return UserWorkoutActivityListResponse();
  }
}
