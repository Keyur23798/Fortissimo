import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortissimo/ApiHelper/ApiHelper.dart';
import 'package:fortissimo/Models/RepeatWorkoutListResponse.dart';
import 'package:fortissimo/Models/WorkoutDetailResponse.dart';
import 'package:fortissimo/Utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddWorkoutSC extends StatefulWidget {
  // const WorkoutDetailSC({Key? key}) : super(key: key);

  String? workoutId;
  String? from;
  AddWorkoutSC({this.workoutId, this.from});

  @override
  _AddWorkoutSCState createState() => _AddWorkoutSCState();
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

class _AddWorkoutSCState extends State<AddWorkoutSC> {
  String weightType = 'Kg';
  String userId = '';
  String workoutName = '';
  String workoutIcon = '';
  String workoutImage = '';
  String baseUrl = '';
  double? metLight;
  double? metHeavy;
  int userWeight = 0;
  List<WorkoutModel> workoutList = [];
  WorkoutDetailResponse? workoutData;
  bool isLoadingWorkoutData = true;
  RepeatWorkoutListResponse? repeatWorkoutList;
  bool isLoadingWorkout = true;
  Utils utils = Utils();

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id') ?? '';
    userWeight = int.parse(prefs.getString('weight') ?? '');
    _getWorkoutDetails(widget.workoutId!);
    if(widget.from == 'Repeat'){
      _getRepeatWorkout(userId);
    }
  }

  _getWorkoutDetails(String workoutId) async {
    setState(() {
      isLoadingWorkoutData = true;
    });
    workoutData = await ApiHelper().workoutDetails(workoutId);
    if (workoutData!.status == 1) {
      setState(() {
        isLoadingWorkoutData = false;
        workoutIcon = workoutData!.data!.first.workoutIcon!;
        workoutImage = workoutData!.data!.first.workoutImage!;
        workoutName = workoutData!.data!.first.workoutName!;
        metLight = double.parse(workoutData!.data!.first.metLight!);
        metHeavy = double.parse(workoutData!.data!.first.metHeavy!);
        baseUrl = workoutData!.baseUrl!;
      });
    } else {
      setState(() {
        isLoadingWorkoutData = false;
      });
      Fluttertoast.showToast(
          msg: workoutData!.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[350],
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  _getRepeatWorkout(String userId) async {
    setState(() {
      isLoadingWorkout = true;
    });
    repeatWorkoutList = await ApiHelper().repeatWorkoutList(userId);
    if (repeatWorkoutList!.status == 1) {
      setState(() {
        isLoadingWorkout = false;
        for(int i =0; i<repeatWorkoutList!.data!.first.workout!.length; i++){
          WorkoutModel workoutModel = WorkoutModel();
          workoutModel.calories_burnt = repeatWorkoutList!.data!.first.workout![i].caloriesBurnt!.toDouble();
          workoutModel.repititions = repeatWorkoutList!.data!.first.workout![i].repititions!;
          workoutModel.weight_unit = repeatWorkoutList!.data!.first.workout![i].weightUnit!;
          workoutModel.weight = repeatWorkoutList!.data!.first.workout![i].weight!;
          workoutModel.workout_id = repeatWorkoutList!.data!.first.workout![i].workoutId!;
          workoutModel.user_id = repeatWorkoutList!.data!.first.workout![i].userId!;
          workoutList.add(workoutModel);
        }
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

  _addWorkout(List<Map<String, dynamic>> addWorkout) async{
    final response = await ApiHelper().addWorkout(addWorkout);
    if (response.status == 1) {
      if (widget.from == 'Repeat') {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: response.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey[350],
            textColor: Colors.black,
            fontSize: 16.0);
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: response.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey[350],
            textColor: Colors.black,
            fontSize: 16.0);
      }
    }else{
      Fluttertoast.showToast(
          msg: response.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
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
                    'Add Workout',
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
              child: (isLoadingWorkoutData == false)?
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(15),
                      child: FancyShimmerImage(
                        imageUrl: '$baseUrl$workoutImage',
                        height: 250,
                        width: double.infinity,
                        boxFit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                    height: 60,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.appBlack, width: 1)),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius:
                          BorderRadius.circular(8),
                          child: FancyShimmerImage(
                            imageUrl: '$baseUrl$workoutIcon',
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
                            workoutName,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              WorkoutModel workout = WorkoutModel();
                              workout.user_id = int.parse(userId);
                              workout.workout_id = int.parse(widget.workoutId!);
                              workout.weight = 0;
                              workout.weight_unit = weightType;
                              workout.repititions = 0;
                              workout.calories_burnt = 0;
                              workoutList.add(workout);
                            });
                          },
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                color: AppColors.appRed,
                                borderRadius: BorderRadius.circular(20)),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.add,
                              color: AppColors.appWhite,
                              size: 25,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Your Workout Details',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[350]!,
                                  offset: Offset(0.0, 4.0),
                                  blurRadius: 6.0)
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      weightType = 'Kg';
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: (weightType == 'Kg')
                                          ? AppColors.appRed
                                          : AppColors.appWhite,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Kg',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: (weightType == 'Kg')
                                              ? AppColors.appWhite
                                              : AppColors.appBlack,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      weightType = 'Lb';
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: (weightType == 'Lb')
                                          ? AppColors.appRed
                                          : AppColors.appWhite,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Lb',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: (weightType == 'Lb')
                                              ? AppColors.appWhite
                                              : AppColors.appBlack,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: workoutList.length,
                          itemBuilder: (context, index) {
                            var data = workoutList[index];
                            return Dismissible(
                              key: UniqueKey(),
                              background: Container(
                                alignment: AlignmentDirectional.centerEnd,
                                color: Colors.red,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) async {
                                workoutList.removeAt(index);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 57,
                                      width: 55,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: AppColors.appRed,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${index + 1}\nSET',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.none,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 15, right: 10),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (data.weight! > 1) {
                                                    data.weight = data.weight! - 1;

                                                    double? met;
                                                    if (data.weight! > 10) {
                                                      met = metHeavy;
                                                    } else {
                                                      met = metLight;
                                                    }
                                                    // int wei = int.parse(weight);
                                                    double cal =
                                                    ((met! * 3.5 * userWeight) /
                                                        200);
                                                    print(cal);

                                                    double? weight;
                                                    if (weightType == 'Kg'){
                                                      setState(() {
                                                        weight = data.weight!.toDouble();
                                                      });
                                                    } else {
                                                      setState(() {
                                                        weight = data.weight!.toDouble()*0.45;
                                                      });
                                                    }
                                                    data.calories_burnt =
                                                        cal * data.repititions!.toDouble()-weight!;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                    color: AppColors.appBlack,
                                                    borderRadius:
                                                    BorderRadius.circular(15)),
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.remove,
                                                  color: AppColors.appWhite,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: Text(
                                                  '${data.weight}\n$weightType',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration.none,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  data.weight = data.weight! + 1;

                                                  double? met;
                                                  if (data.weight! > 10) {
                                                    met = metHeavy;
                                                  } else {
                                                    met = metLight;
                                                  }
                                                  // int wei = int.parse(weight);
                                                  double cal =
                                                  ((met! * 3.5 * userWeight) /
                                                      200);
                                                  print(cal);

                                                  double? weight;
                                                  if (weightType == 'Kg'){
                                                    setState(() {
                                                      weight = data.weight!.toDouble();
                                                    });
                                                  } else {
                                                    setState(() {
                                                      weight = data.weight!.toDouble()*0.45;
                                                    });
                                                  }
                                                  data.calories_burnt =
                                                      cal * data.repititions!.toDouble()+weight!;
                                                });
                                              },
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                    color: AppColors.appBlack,
                                                    borderRadius:
                                                    BorderRadius.circular(15)),
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.add,
                                                  color: AppColors.appWhite,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10, right: 15),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (data.weight! > 0){
                                                    if (data.repititions! > 1) {
                                                      data.repititions = data.repititions! - 1;

                                                      double? met;
                                                      if (data.weight! > 10) {
                                                        met = metHeavy;
                                                      } else {
                                                        met = metLight;
                                                      }

                                                      double cal =
                                                      ((met! * 3.5 * userWeight) /
                                                          200);
                                                      print(cal);
                                                      var val =
                                                          cal * data.repititions!.toDouble();
                                                      data.calories_burnt = val;
                                                    }
                                                  }
                                                });
                                              },
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                    color: AppColors.appBlack,
                                                    borderRadius:
                                                    BorderRadius.circular(15)),
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.remove,
                                                  color: AppColors.appWhite,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: Text(
                                                  '${data.repititions}\nReps',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration.none,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if(data.weight! > 0){
                                                    data.repititions = data.repititions! + 1;

                                                    double? met;
                                                    if (data.weight! > 10) {
                                                      met = metHeavy;
                                                    } else {
                                                      met = metLight;
                                                    }

                                                    double cal =
                                                    ((met! * 3.5 * userWeight) /
                                                        200);
                                                    print(cal);
                                                    var val =
                                                        cal * data.repititions!.toDouble();
                                                    data.calories_burnt = val;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                    color: AppColors.appBlack,
                                                    borderRadius:
                                                    BorderRadius.circular(15)),
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.add,
                                                  color: AppColors.appWhite,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 57,
                                      width: 55,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: AppColors.appRed,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/fire.svg',
                                            height: 15,
                                            width: 15,
                                            color: AppColors.appWhite,
                                          ),
                                          SizedBox(
                                            height: 0,
                                          ),
                                          Text(
                                            '${data.calories_burnt!.toStringAsFixed(0)}\nKcal',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.appWhite,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ):
              Center(
                child: CircularProgressIndicator(
                  color: AppColors.appRed,
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.appRed,
        ),
        child: FlatButton(
          onPressed: () {
            print("ListAdd"+workoutList.first.toString());

            List<Map<String, dynamic>> send=[] ;
            for(int i =0; i<workoutList.length;i++){
              print("ListAdd"+workoutList[i].weight.toString());
              Map<String, dynamic> myObject = {"user_id": workoutList[i].user_id.toString(), "workout_id": workoutList[i].workout_id.toString(), "weight": workoutList[i].weight.toString(), "weight_unit": workoutList[i].weight_unit.toString(), "repititions": workoutList[i].repititions.toString(),"calories_burnt":workoutList[i].calories_burnt.toString()} ;
              send.add(myObject);
            }

            if(workoutList.length > 0){
              bool valid = false;
              workoutList.forEach((w){
                if(w.weight! <= 0 || w.repititions! <= 0){
                  setState(() {
                    valid = false;
                  });
                } else {
                  setState(() {
                    valid = true;
                  });
                }
              });

              if (valid == true){
                utils.progressDialogue(context);
                _addWorkout(send);
              } else {
                Fluttertoast.showToast(
                    msg: "Please add value more than 0",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey[350],
                    textColor: Colors.black,
                    fontSize: 16.0);
              }

            } else {
              Fluttertoast.showToast(
                  msg: "Please add workout",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey[350],
                  textColor: Colors.black,
                  fontSize: 16.0);
            }

          },
          child: Text(
            'Finish',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
