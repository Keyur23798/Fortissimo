import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortissimo/ApiHelper/ApiHelper.dart';
import 'package:fortissimo/Models/RepeatWorkoutListResponse.dart';
import 'package:fortissimo/Utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddWorkout.dart';

class RepeatWorkoutSC extends StatefulWidget {
  const RepeatWorkoutSC({Key? key}) : super(key: key);

  @override
  _RepeatWorkoutSCState createState() => _RepeatWorkoutSCState();
}

class WorkoutModel {
  int? user_id;
  int? workout_id;
  int? weight;
  String? weight_unit;
  int? repititions;
  double? calories_burnt;

  WorkoutModel({
    this.user_id,
    this.workout_id,
    this.weight,
    this.weight_unit,
    this.repititions,
    this.calories_burnt,
  });
}

class _RepeatWorkoutSCState extends State<RepeatWorkoutSC> {
  RepeatWorkoutListResponse? repeatWorkoutList;
  bool isLoadingWorkout = true;
  String userId = '';

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id') ?? '';

    _getRepeatWorkout(userId);
  }

  _getRepeatWorkout(String userId) async {
    setState(() {
      isLoadingWorkout = true;
    });
    repeatWorkoutList = await ApiHelper().repeatWorkoutList(userId);
    if (repeatWorkoutList!.status == 1) {
      setState(() {
        isLoadingWorkout = false;
      });
    } else {
      setState(() {
        isLoadingWorkout = false;
      });
      Fluttertoast.showToast(
          msg: repeatWorkoutList!.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[350],
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.black,
                      size: 25,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Repeat Workout',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 40,
                  )
                ],
              ),
            ),
            Expanded(
              child: (isLoadingWorkout == false) ?
              Container(
                padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                child: (repeatWorkoutList!.data!.isNotEmpty) ?
                ListView.builder(
                  itemCount: repeatWorkoutList!.data!.length,
                  itemBuilder: (context, index) {
                    var data = repeatWorkoutList!.data![index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddWorkoutSC(
                                  workoutId: repeatWorkoutList!
                                      .data!.first.workoutId.toString(),
                                  from: 'Repeat',
                                ))).then((value) => _getRepeatWorkout(userId));
                      },
                      child: Container(
                        height: 60,
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppColors.appWhite,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: Colors.black45, width: 1)),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                              BorderRadius.circular(8),
                              child: FancyShimmerImage(
                                imageUrl: '${repeatWorkoutList!.baseUrl}${data.workoutIcon!}',
                                height: 40,
                                width: 40,
                                boxFit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                data.workoutName!,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.appWhite,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/fire.svg',
                                    height: 20,
                                    width: 20,
                                    color: AppColors.appBlack,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    data.caloriesBurnt!,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.appRed,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ) :
                Center(
                  child: Text("No Workout Found"),
                ),
              ) :
              Center(
                child: CircularProgressIndicator(
                  color: AppColors.appRed,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
