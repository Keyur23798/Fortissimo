import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortissimo/ApiHelper/ApiHelper.dart';
import 'package:fortissimo/Models/DeleteActivityResponse.dart';
import 'package:fortissimo/Models/UserWorkoutActivityListResponse.dart';
import 'package:fortissimo/Utils/Utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodayWorkoutActivitySC extends StatefulWidget {
  // const TodayWorkoutActivitySC({Key? key}) : super(key: key);

  String? workoutId = "";
  String? workoutIcon = "";
  String? baseUrl = "";
  TodayWorkoutActivitySC({this.workoutId, this.workoutIcon, this.baseUrl});

  @override
  _TodayWorkoutActivitySCState createState() => _TodayWorkoutActivitySCState();
}

class _TodayWorkoutActivitySCState extends State<TodayWorkoutActivitySC> {
  UserWorkoutActivityListResponse? workoutActivityList;
  DeleteActivityResponse? response;
  bool isLoadingWorkoutActivity = true;
  bool isLoadingDelete = true;
  String userId = '';
  File? _image;
  var scr = new GlobalKey();
  Utils util = Utils();

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id') ?? '';

    _getWorkoutActivity(userId, widget.workoutId!);
  }

  _getWorkoutActivity(String userId, String workoutId) async {
    setState(() {
      isLoadingWorkoutActivity = true;
    });
    workoutActivityList =
        await ApiHelper().workoutActivityList(userId, workoutId);
    if (workoutActivityList!.status == 1) {
      setState(() {
        isLoadingWorkoutActivity = false;
      });
    } else {
      setState(() {
        isLoadingWorkoutActivity = false;
      });
      Fluttertoast.showToast(
          msg: workoutActivityList!.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[350],
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  _deleteWorkoutActivity(String workoutId) async {
    setState(() {
      isLoadingDelete = true;
    });
    response = await ApiHelper().deleteWorkout(userId, workoutId);
    if (response!.status == 1) {
      setState(() {
        isLoadingDelete = false;
      });
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      setState(() {
        isLoadingDelete = false;
      });
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: response!.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[350],
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  Future<void> _captureSocialPng() {
    List<String> imagePaths = [];
    final RenderBox box = context.findRenderObject() as RenderBox;
    return new Future.delayed(const Duration(milliseconds: 20), () async {
      RenderRepaintBoundary? boundary =
          scr.currentContext!.findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage();
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = new File('$directory/screenshot.png');
      imagePaths.add(imgFile.path);
      imgFile.writeAsBytes(pngBytes).then((value) async {
        await Share.shareFiles(imagePaths,
            subject: 'Share',
            text: 'Check this Out!',
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      }).catchError((onError) {
        print(onError);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: (isLoadingWorkoutActivity == false)
              ? Container(
                  child: (workoutActivityList!.data!.isNotEmpty)
                      ? RepaintBoundary(
                          key: scr,
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: 25, right: 25, top: 80, bottom: 80),
                              padding: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                  color: AppColors.appRed,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 40,
                                      ),
                                      Image(
                                        image:
                                            AssetImage('assets/logoWhite.png'),
                                        height: 50,
                                        width: 120,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: AppColors.appBlack,
                                          size: 25,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 65,
                                          width: 65,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppColors.appWhite,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: FancyShimmerImage(
                                              imageUrl:
                                                  '${widget.baseUrl}${widget.workoutIcon}',
                                              height: 40,
                                              width: 40,
                                              boxFit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 65,
                                          width: 65,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppColors.appWhite,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '${workoutActivityList!.set}\nSET',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: AppColors.appBlack,
                                              fontWeight: FontWeight.w500,
                                              decoration: TextDecoration.none,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Container(
                                          height: 65,
                                          width: 65,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: AppColors.appWhite,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: SvgPicture.asset(
                                                    'assets/fire.svg',
                                                    color: AppColors.appBlack,
                                                    height: 20,
                                                    width: 20),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Text(
                                                  '${workoutActivityList!.total}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: AppColors.appBlack,
                                                    fontWeight: FontWeight.w500,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      '${workoutActivityList!.data!.first.workoutName}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.appWhite,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Workout List',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.appBlack,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Container(
                                      height: 250,
                                      decoration: BoxDecoration(
                                          color: AppColors.appWhite,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Scrollbar(
                                        child: ListView.builder(
                                          itemCount:
                                              workoutActivityList!.data!.length,
                                          itemBuilder: (context, index) {
                                            var data = workoutActivityList!
                                                .data![index];
                                            return Container(
                                              height: 35,
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              margin:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      '${data.weight} ${data.weightUnit} - ${data.repititions} reps',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            AppColors.appBlack,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        decoration:
                                                            TextDecoration.none,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5, right: 5),
                                                    child: SvgPicture.asset(
                                                        'assets/fire.svg',
                                                        color: AppColors.appRed,
                                                        height: 20,
                                                        width: 20),
                                                  ),
                                                  Text(
                                                    '${data.caloriesBurnt}',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: AppColors.appRed,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decoration:
                                                          TextDecoration.none,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              util.progressDialogue(context);
                                              _deleteWorkoutActivity(
                                                  widget.workoutId!);
                                            },
                                            child: Container(
                                              height: 40,
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: AppColors.appRed,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      color: AppColors.appWhite,
                                                      width: 1)),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.appWhite,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              _captureSocialPng();
                                            },
                                            child: Container(
                                              height: 40,
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: AppColors.appBlack,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Share',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.appWhite,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        )
                      : Center(
                          child: Text(
                            "No Records Found",
                            style: TextStyle(
                                fontSize: 15,
                                color: AppColors.appBlack,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: AppColors.appRed,
                  ),
                ),
        ),
      ),
    );
  }
}
