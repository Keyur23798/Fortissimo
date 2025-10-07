import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortissimo/ApiHelper/ApiHelper.dart';
import 'package:fortissimo/Models/MuscleListResponse.dart';
import 'package:fortissimo/Models/WorkoutListResponse.dart';
import 'package:fortissimo/Models/WorkoutDetailResponse.dart';
import 'package:fortissimo/Screens/AddWorkout.dart';
import 'package:fortissimo/Utils/Utils.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SearchSC extends StatefulWidget {
  const SearchSC({Key? key}) : super(key: key);

  @override
  _SearchSCState createState() => _SearchSCState();
}

class _SearchSCState extends State<SearchSC> {
  TextEditingController searchController = TextEditingController();
  String selectedId = '0';
  MuscleListResponse? muscleCategoryList;
  WorkoutListResponse? workoutListResponse;
  List<WorkoutList> workoutList = [];
  WorkoutDetailResponse? workoutData;
  bool isLoadingWorkout = true;
  bool isLoadingWorkoutData = true;
  bool isLoadingCategory = true;
  String baseUrl = '';
  String equipmentImage = '';

  @override
  void initState() {
    super.initState();
    _getCategory();
  }

  _getCategory() async {
    setState(() {
      isLoadingCategory = true;
    });
    muscleCategoryList = await ApiHelper().getMuscleList();
    if (muscleCategoryList!.status == 1) {
      setState(() {
        if (selectedId == '') {
          muscleCategoryList!.data!.first.isSelected = true;
        }
        selectedId = muscleCategoryList!.data!.first.muscleId.toString();
        isLoadingCategory = false;
      });
      _getWorkout(selectedId);
    } else {
      setState(() {
        isLoadingCategory = false;
        isLoadingWorkout = false;
      });
      Fluttertoast.showToast(
          msg: muscleCategoryList!.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[350],
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  _getWorkout(String muscleId) async {
    setState(() {
      isLoadingWorkout = true;
    });
    workoutListResponse = await ApiHelper().workoutList(muscleId);
    if (workoutListResponse!.status == 1) {
      setState(() {
        isLoadingWorkout = false;
        workoutList = workoutListResponse!.data!;
        baseUrl = workoutListResponse!.baseUrl!;
        // _searchResult = workoutListResponse!.data!;
      });
    } else {
      setState(() {
        isLoadingWorkout = false;
      });
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
        equipmentImage = workoutData!.data!.first.equipmentImage ?? '';
        _workoutDetailsPopup(context);
      });
    } else {
      setState(() {
        isLoadingWorkoutData = false;
      });
    }
  }

  _workoutDetailsPopup(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: AppColors.appWhite,
      topRadius: Radius.circular(25),
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: (isLoadingWorkoutData == false)
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
                padding: EdgeInsets.only(top: 5, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 25,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      margin: EdgeInsets.only(bottom: 15),
                      child: Container(
                        width: 75,
                        child: Divider(
                          height: 10,
                          thickness: 2.5,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(15),
                        child: FancyShimmerImage(
                          imageUrl: '${workoutData!.baseUrl}${workoutData!.data!.first.workoutImage!}',
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
                          border:
                              Border.all(color: AppColors.appBlack, width: 1)),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                            BorderRadius.circular(8),
                            child: FancyShimmerImage(
                              imageUrl: '${workoutData!.baseUrl}${workoutData!.data!.first.workoutIcon!}',
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
                              workoutData!.data!.first.workoutName!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 0),
                      margin: EdgeInsets.only(
                          bottom: 10, top: 15, left: 15, right: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.appRed,
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddWorkoutSC(
                                        workoutId: workoutData!
                                            .data!.first.workoutId.toString(),
                                        from: 'Search',
                                      )));
                        },
                        child: Text(
                          'Start Workout',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: equipmentImage.isNotEmpty ? true : false,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                        child: Text(
                          'Equipment :',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: equipmentImage.isNotEmpty ? true : false,
                      child: Padding(
                        padding: EdgeInsets.only(left: 25, right: 25, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                              BorderRadius.circular(15),
                              child: FancyShimmerImage(
                                imageUrl: '${workoutData!.baseUrl}$equipmentImage',
                                height: 120,
                                width: 160,
                                boxFit: BoxFit.fitHeight,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                workoutData!.data!.first.equipmentName ?? '',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: Text(
                        'Workout Description :',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: Html(
                        data: workoutData!.data!.first.workoutDescription!,
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: AppColors.appRed,
                ),
              ),
      ),
    );
  }

  _searchWorkout(String text) async {
    setState(() {
      isLoadingWorkout = true;
      workoutList.clear();
    });
    workoutListResponse = await ApiHelper().searchWorkout(text);
    if (workoutListResponse!.status == 1) {
      setState(() {
        isLoadingWorkout = false;
        baseUrl = workoutListResponse!.baseUrl!;
        workoutList = workoutListResponse!.data!;
      });
    } else {
      setState(() {
        isLoadingWorkout = false;
      });
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
                    'All Exercise',
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
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                textInputAction: TextInputAction.done,
                controller: searchController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Search Something',
                  border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(12.0),
                      ),
                      borderSide: BorderSide.none),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.appRed,
                  ),
                ),
                onChanged: (text){
                  if(text.length >= 2){
                    _searchWorkout(text);
                  }else {
                    _getWorkout(selectedId);
                  }
                },
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: (isLoadingCategory == false)
                  ? Container(
                      child: (muscleCategoryList!.data!.isNotEmpty)
                          ? ListView.builder(
                              itemCount: muscleCategoryList!.data!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                var category = muscleCategoryList!.data![index];
                                return GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      for (int i = 0;
                                          i < muscleCategoryList!.data!.length;
                                          i++) {
                                        if (muscleCategoryList!
                                                .data![i].muscleId ==
                                            category.muscleId) {
                                          setState(() {
                                            category.isSelected = true;
                                          });
                                        } else {
                                          setState(() {
                                            category.isSelected = false;
                                          });
                                        }
                                      }
                                      selectedId = category.muscleId.toString();
                                    });
                                    _getWorkout(selectedId);
                                  },
                                  child: Container(
                                    height: 40,
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: (selectedId ==
                                              category.muscleId.toString())
                                          ? AppColors.appRed
                                          : Colors.grey[300],
                                    ),
                                    padding: EdgeInsets.all(7),
                                    alignment: Alignment.center,
                                    child: Text(category.muscleName.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        style: TextStyle(
                                            color: (selectedId ==
                                                    category.muscleId
                                                        .toString())
                                                ? AppColors.appWhite
                                                : AppColors.appBlack,
                                            fontSize: 15,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text("No Category Found"),
                            ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: AppColors.appRed,
                      ),
                    ),
            ),
            Expanded(
              child: (isLoadingWorkout == false)
                  ? Container(
                      child: (workoutList.isNotEmpty)
                          ? ListView.builder(
                              itemCount: workoutList.length,
                              itemBuilder: (context, index) {
                                var data = workoutList[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddWorkoutSC(
                                                  workoutId: data.workoutId.toString(),
                                                  from: 'Search',
                                                )));
                                  },
                                  child: Container(
                                    height: 60,
                                    margin: EdgeInsets.only(
                                        bottom: 10, right: 20, left: 20),
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
                                            imageUrl: '$baseUrl${data.workoutIcon!}',
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
                                        IconButton(
                                          icon: Icon(
                                            Icons.info_outline_rounded,
                                            color: Colors.grey,
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            _getWorkoutDetails(
                                                data.workoutId.toString());
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text("No Workout Found"),
                            ),
                    )
                  : Center(
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
