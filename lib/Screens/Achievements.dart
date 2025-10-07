import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortissimo/ApiHelper/ApiHelper.dart';
import 'package:fortissimo/Models/AchievementResponse.dart';
import 'package:fortissimo/Models/HightestWorkoutListResponse.dart';
import 'package:fortissimo/Screens/Search.dart';
import 'package:fortissimo/Utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AchievementSC extends StatefulWidget {
  const AchievementSC({Key? key}) : super(key: key);

  @override
  _AchievementSCState createState() => _AchievementSCState();
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class _AchievementSCState extends State<AchievementSC> with SingleTickerProviderStateMixin {
  TabController? _controller;
  int _selectedIndex = 0;
  String type = 'Week';
  String userId = '';
  HightestWorkoutListResponse? highestWorkoutList;
  bool isLoadingWorkout = true;
  AchievementResponse? achievementResponse;
  bool isLoadingAchievement = true;
  List<Widget> list = [
    Tab(
      child: Text('Statistics'),
    ),
    Tab(
      child: Text('Graphs'),
    ),
  ];
  List<WeekWiseAchievements> weekWiseAchievements = [];
  List<MonthWiseAchievements> monthWiseAchievements = [];
  List<YearWiseAchievements> yearWiseAchievements = [];

  bool isWeekVisible = false;
  bool isMonthVisible = false;
  bool isYearVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: list.length, vsync: this);
    _controller!.addListener(() {
      setState(() {
        _selectedIndex = _controller!.index;
      });
      print("Selected Index: " + _controller!.index.toString());
    });

    _getUserDetails();
  }

  _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id') ?? '';

    _getHighestWorkout(userId);
    _getAhievement(userId);
  }

  _getHighestWorkout(String userId) async {
    setState(() {
      isLoadingWorkout = true;
    });
    highestWorkoutList = await ApiHelper().highestWorkout(userId);
    if (highestWorkoutList!.status == 1) {
      setState(() {
        isLoadingWorkout = false;
      });
    } else {
      setState(() {
        isLoadingWorkout = false;
      });
      Fluttertoast.showToast(
          msg: highestWorkoutList!.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[350],
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  _getAhievement(String userId) async {
    setState(() {
      isLoadingAchievement = true;
    });
    achievementResponse = await ApiHelper().getAhievement(userId);
    if (achievementResponse!.status == 1) {
      setState(() {
        isLoadingAchievement = false;
        weekWiseAchievements = achievementResponse!.weekWiseAchievements!;
        monthWiseAchievements = achievementResponse!.monthWiseAchievements!;
        yearWiseAchievements = achievementResponse!.yearWiseAchievements!;

        // if(weekWiseAchievements.isNotEmpty){
        //   setState(() {
        //     isWeekVisible = true;
        //   });
        // }
        setState(() {
          isWeekVisible = true;
        });

      });
    } else {
      setState(() {
        isLoadingAchievement = false;
      });
      Fluttertoast.showToast(
          msg: achievementResponse!.message.toString(),
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
                    'Achievements',
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
              height: 30,
              child: TabBar(
                indicatorColor: AppColors.appRed,
                unselectedLabelColor: AppColors.appRed,
                labelColor: AppColors.appRed,
                controller: _controller,
                isScrollable: false,
                onTap: (index) {
                  // Tab index when user select it, it start from zero
                },
                tabs: list,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Exercises Name',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.appBlack,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                Text(
                                  'Your Best',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.appBlack,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: (isLoadingWorkout == false)?
                            Container(
                              child: (highestWorkoutList!.data!.isNotEmpty) ?
                              ListView.builder(
                                itemCount: highestWorkoutList!.data!.length,
                                itemBuilder: (context, index) {
                                  var data = highestWorkoutList!.data![index];
                                  return GestureDetector(
                                    onTap: (){

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
                                              imageUrl: '${highestWorkoutList!.baseUrl}${data.workoutIcon!}',
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
                                            child: Text(
                                              '${data.weight!} Kg',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColors.appRed,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ) :
                              Center(
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SearchSC()));
                                  },
                                  child: Text(
                                    "No Records Found\nLet's Start Work",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: AppColors.appBlack,
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ):
                            Center(
                              child: CircularProgressIndicator(
                                color: AppColors.appRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(left: 20,right: 20,top: 10),
                      child: Column(
                        children: [
                          Container(
                            height: 40,
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
                                    onTap: (){
                                      setState(() {
                                        type = 'Week';
                                        setState(() {
                                          isWeekVisible = true;
                                          isMonthVisible = false;
                                          isYearVisible = false;
                                        });

                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: (type == 'Week') ? AppColors.appRed : AppColors.appWhite,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Week',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: (type == 'Week') ? AppColors.appWhite : AppColors.appBlack,
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        type = 'Month';
                                        setState(() {
                                          isWeekVisible = false;
                                          isMonthVisible = true;
                                          isYearVisible = false;
                                        });
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: (type == 'Month') ? AppColors.appRed : AppColors.appWhite,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Month',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: (type == 'Month') ? AppColors.appWhite : AppColors.appBlack,
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        type = 'Year';
                                        setState(() {
                                          isWeekVisible = false;
                                          isMonthVisible = false;
                                          isYearVisible = true;
                                        });
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: (type == 'Year') ? AppColors.appRed : AppColors.appWhite,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Year',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: (type == 'Year') ? AppColors.appWhite : AppColors.appBlack,
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isWeekVisible,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  title: ChartTitle(text: 'Week Wise Workout Analysis'),
                                  legend: Legend(isVisible: true),
                                  borderColor: AppColors.appRed,
                                  borderWidth: 1,
                                  tooltipBehavior: TooltipBehavior(enable: true),
                                  series: <ChartSeries<WeekWiseAchievements, String>>[
                                    LineSeries<WeekWiseAchievements, String>(
                                        dataSource: weekWiseAchievements,
                                        xValueMapper: (WeekWiseAchievements sales, _) => sales.day,
                                        yValueMapper: (WeekWiseAchievements sales, _) => double.parse(sales.caloriesBurnt.toString()),
                                        name: 'Workout',
                                        color: AppColors.appRed,
                                        dataLabelSettings: DataLabelSettings(isVisible: true))
                                  ]),
                            ),
                          ),
                          Visibility(
                            visible: isMonthVisible,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  title: ChartTitle(text: 'Month Wise Workout Analysis'),
                                  legend: Legend(isVisible: true),
                                  borderColor: AppColors.appRed,
                                  borderWidth: 1,
                                  tooltipBehavior: TooltipBehavior(enable: true),
                                  series: <ChartSeries<MonthWiseAchievements, String>>[
                                    LineSeries<MonthWiseAchievements, String>(
                                        dataSource: monthWiseAchievements,
                                        xValueMapper: (MonthWiseAchievements sales, _) => sales.date,
                                        yValueMapper: (MonthWiseAchievements sales, _) => double.parse(sales.caloriesBurnt.toString()),
                                        name: 'Workout',
                                        color: AppColors.appRed,
                                        dataLabelSettings: DataLabelSettings(isVisible: true))
                                  ]),
                            ),
                          ),
                          Visibility(
                            visible: isYearVisible,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  title: ChartTitle(text: 'Year Wise Workout Analysis'),
                                  legend: Legend(isVisible: true),
                                  borderColor: AppColors.appRed,
                                  borderWidth: 1,
                                  tooltipBehavior: TooltipBehavior(enable: true),
                                  series: <ChartSeries<YearWiseAchievements, String>>[
                                    LineSeries<YearWiseAchievements, String>(
                                        dataSource: yearWiseAchievements,
                                        xValueMapper: (YearWiseAchievements sales, _) => sales.monthname.toString(),
                                        yValueMapper: (YearWiseAchievements sales, _) => double.parse(sales.caloriesBurnt.toString()),
                                        name: 'Workout',
                                        color: AppColors.appRed,
                                        dataLabelSettings: DataLabelSettings(isVisible: true))
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
