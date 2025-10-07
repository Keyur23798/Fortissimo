import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortissimo/ApiHelper/ApiHelper.dart';
import 'package:fortissimo/Models/TodayTotalWorkoutResponse.dart';
import 'package:fortissimo/Models/TodayWorkoutListResponse.dart';
import 'package:fortissimo/Screens/Achievements.dart';
import 'package:fortissimo/Screens/CompanyProfile.dart';
import 'package:fortissimo/Screens/Notification.dart';
import 'package:fortissimo/Screens/Profile.dart';
import 'package:fortissimo/Screens/RepeatWorkout.dart';
import 'package:fortissimo/Screens/Search.dart';
import 'package:fortissimo/Screens/TodayWorkoutActivity.dart';
import 'package:fortissimo/Utils/Utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'Login.dart';

class HomeSC extends StatefulWidget {
  const HomeSC({Key? key}) : super(key: key);

  @override
  _HomeSCState createState() => _HomeSCState();
}

class _HomeSCState extends State<HomeSC> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  TodayWorkoutListResponse? todayWorkoutList;
  TodayTotalWorkoutResponse? todayTotalWorkout;
  bool isLoadingWorkout = true;
  bool isLoadingTotalWorkout = true;
  String todayDate = '';
  String todayMonth = '';
  String userName = '';
  String userId = '';
  String userEmail = '';
  String userHeight = '';
  String userHeightUnit = '';
  String userWeight = '';
  String userWeightUnit = '';
  String userAge = '';
  String userProfilePic = '';
  String userProfilePicUrl = '';
  String workoutGoal = '';
  double totalWorkout = 0;

  @override
  void initState() {
    super.initState();
    _getUserDetails();

    setState(() {
      var now = new DateTime.now();
      var formatter = new DateFormat('dd');
      var formatter1 = new DateFormat('MMMM');
      todayDate = formatter.format(now);
      todayMonth = formatter1.format(now);
    });
  }

  _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName') ?? '';
    userId = prefs.getString('id') ?? '';
    userEmail = prefs.getString('email') ?? '';
    userWeight = prefs.getString('weight') ?? '';
    userWeightUnit = prefs.getString('weightUnit') ?? '';
    userHeight = prefs.getString('height') ?? '';
    userHeightUnit = prefs.getString('heightUnit') ?? '';
    userAge = prefs.getString('age') ?? '';
    userProfilePic = prefs.getString('profilePic') ?? '';
    userProfilePicUrl = prefs.getString('profilePicUrl') ?? '';
    workoutGoal = prefs.getString('workoutGoal') ?? '';

    _getWorkout(userId);
    _getTotalWorkout(userId);
  }

  _getTotalWorkout(String userId) async {
    setState(() {
      isLoadingTotalWorkout = true;
    });
    todayTotalWorkout = await ApiHelper().todayTotalWorkout(userId);
    if (todayTotalWorkout!.status == 1) {
      setState(() {
        isLoadingTotalWorkout = false;
        totalWorkout = todayTotalWorkout!.todayTotalWorkout!.toDouble();
      });
    } else {
      setState(() {
        isLoadingTotalWorkout = false;
      });
      Fluttertoast.showToast(
          msg: todayTotalWorkout!.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[350],
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  _getWorkout(String userId) async {
    setState(() {
      isLoadingWorkout = true;
    });
    todayWorkoutList = await ApiHelper().todayWorkout(userId);
    if (todayWorkoutList!.status == 1) {
      setState(() {
        isLoadingWorkout = false;
      });
    } else {
      setState(() {
        isLoadingWorkout = false;
      });
      Fluttertoast.showToast(
          msg: todayWorkoutList!.message.toString(),
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
      backgroundColor: AppColors.appWhite,
      key: _scaffoldKey,
      drawerScrimColor: AppColors.appBlack.withOpacity(0.3),
      drawerEdgeDragWidth: 40,
      drawer: SafeArea(
        child: Container(
          width: 325,
          child: Drawer(
            child: Column(
              children: [
                Container(
                  color: AppColors.appRed,
                  height: 275,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: AppColors.appBlack,
                        child: (userProfilePic == '')
                            ? Padding(
                                padding: EdgeInsets.all(15),
                                child: Image(
                                  image: AssetImage('assets/logoWhite.png'),
                                ),
                              )
                            : (userProfilePicUrl == '') ?
                        ClipOval(
                                child: Image.network(
                                '$userProfilePic',
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              ),
                        ) :
                        ClipOval(
                          child: Image.network(
                            '$userProfilePicUrl',
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          userName,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.appWhite,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 80,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: AppColors.appBlack,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    SvgPicture.asset('assets/weight.svg',
                                        height: 18, width: 18),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        '$userWeight $userWeightUnit',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.appWhite,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                height: 80,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: AppColors.appBlack,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    SvgPicture.asset('assets/height.svg',
                                        height: 18, width: 18),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        '$userHeight $userHeightUnit',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.appWhite,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                height: 80,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: AppColors.appBlack,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    SvgPicture.asset('assets/cake.svg',
                                        height: 20, width: 20),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        '$userAge Years',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.appWhite,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.none,
                                        ),
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
                ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    ListTile(
                      leading: SvgPicture.asset('assets/profile.svg',
                          color: AppColors.appRed, height: 20, width: 20),
                      title: Text(
                        'Profile',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: Colors.grey,
                      ),
                      onTap: () async {
                        _scaffoldKey.currentState!.openEndDrawer();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileSC(
                                      email: userEmail,
                                      name: userName,
                                      from: "Home",
                                    ))).then((value) => _getUserDetails());
                      },
                    ),
                    ListTile(
                      leading: SvgPicture.asset('assets/achievement.svg',
                          color: AppColors.appRed, height: 22, width: 22),
                      title: Text(
                        'Achievements',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: Colors.grey,
                      ),
                      onTap: () async {
                        _scaffoldKey.currentState!.openEndDrawer();
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AchievementSC()))
                            .then((value) => _getUserDetails());
                      },
                    ),
                    ListTile(
                      leading: SvgPicture.asset('assets/aboutus.svg',
                          color: AppColors.appRed, height: 20, width: 20),
                      title: Text(
                        'About Us',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: Colors.grey,
                      ),
                      onTap: () async {
                        _scaffoldKey.currentState!.openEndDrawer();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CompanyProfileSC(type: "About Us")));
                      },
                    ),
                    ListTile(
                      leading: SvgPicture.asset('assets/terms.svg',
                          color: AppColors.appRed, height: 22, width: 22),
                      title: Text(
                        'Terms & Conditions',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: Colors.grey,
                      ),
                      onTap: () async {
                        _scaffoldKey.currentState!.openEndDrawer();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompanyProfileSC(
                                    type: "Terms & Conditions")));
                      },
                    ),
                    ListTile(
                      leading: SvgPicture.asset('assets/privacypolicy.svg',
                          color: AppColors.appRed, height: 22, width: 22),
                      title: Text(
                        'Privacy Policy',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: Colors.grey,
                      ),
                      onTap: () async {
                        _scaffoldKey.currentState!.openEndDrawer();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CompanyProfileSC(type: "Privacy Policy")));
                      },
                    ),
                    // ListTile(
                    //   leading: SvgPicture.asset('assets/feedback.svg',
                    //       color: AppColors.appRed, height: 22, width: 22),
                    //   title: Text(
                    //     'Feedback',
                    //     style: TextStyle(
                    //         color: Colors.black,
                    //         fontSize: 16,
                    //         decoration: TextDecoration.none,
                    //         fontWeight: FontWeight.w500),
                    //   ),
                    //   trailing: Icon(
                    //     Icons.chevron_right,
                    //     size: 30,
                    //     color: Colors.grey,
                    //   ),
                    //   onTap: () async {
                    //     _scaffoldKey.currentState!.openEndDrawer();
                    //   },
                    // ),
                    ListTile(
                      leading: SvgPicture.asset('assets/logout.svg',
                          color: AppColors.appRed, height: 20, width: 20),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: Colors.grey,
                      ),
                      onTap: () async {
                        _scaffoldKey.currentState!.openEndDrawer();
                        showDialog(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.65),
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    scrollable: false,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    content: Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Are you sure you want to\nLogout ?',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              decoration: TextDecoration.none,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  width: 120,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: AppColors.appBlack,
                                                  ),
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      'CANCEL',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  width: 120,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: AppColors.appRed,
                                                  ),
                                                  child: FlatButton(
                                                    onPressed: () async {
                                                      /*await FirebaseAuth.instance.signOut();*/
                                                      SharedPreferences prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      _googleSignIn
                                                          .signOut()
                                                          .then((value) {
                                                        prefs.setBool(
                                                            "isLoggedIn",
                                                            false);
                                                      }).catchError((e) {});
                                                      prefs.clear();
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      LoginSC()));
                                                    },
                                                    child: Text(
                                                      'OK',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: SvgPicture.asset('assets/sideMenu.svg',
                        height: 15, width: 15),
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  Image(
                    image: AssetImage('assets/logoRed.png'),
                    height: 50,
                    width: 120,
                  ),
                  IconButton(
                    icon: Image.asset('assets/bell.png', height: 25, width: 25),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationSC()));
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 25, right: 20, top: 15),
                          child: Text(
                            'Hi, $userName 👋',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: AppColors.appWhite,
                                child: SleekCircularSlider(
                                  min: 0,
                                  max: double.parse(workoutGoal),
                                  initialValue: (totalWorkout >=
                                          double.parse(workoutGoal))
                                      ? double.parse(workoutGoal)
                                      : totalWorkout,
                                  appearance: CircularSliderAppearance(
                                      spinnerMode: false,
                                      size: MediaQuery.of(context).size.width * 0.45,
                                      startAngle: 270.0,
                                      angleRange: 360,
                                      animDurationMultiplier: 1.5,
                                      infoProperties: InfoProperties(
                                        topLabelText: 'Workout',
                                        topLabelStyle: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                        bottomLabelText: 'Total of 3 Exercise',
                                        bottomLabelStyle: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                        mainLabelStyle: TextStyle(
                                            color: AppColors.appBlack,
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      customColors: CustomSliderColors(
                                        progressBarColor: AppColors.appRed,
                                        dotColor: AppColors.appRed,
                                        dynamicGradient: false,
                                        hideShadow: true,
                                        trackColor: AppColors.appBg,
                                      ),
                                      customWidths: CustomSliderWidths(
                                        trackWidth: 20,
                                      )),
                                  // onChange: (double value) {
                                  //   // callback providing a value while its being changed (with a pan gesture)
                                  // },
                                  // onChangeStart: (double startValue) {
                                  //   // callback providing a starting value (when a pan gesture starts)
                                  // },
                                  // onChangeEnd: (double endValue) {
                                  //   // ucallback providing an ending value (when a pan gesture ends)
                                  // },
                                  innerWidget: (double value) {
                                    // use your custom widget inside the slider (gets a slider value from the callback)
                                    return Center(
                                      child: (isLoadingTotalWorkout == false)
                                          ? Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 8),
                                                    child: SvgPicture.asset(
                                                      'assets/fire.svg',
                                                      height: 25,
                                                      width: 25,
                                                      color: AppColors.appRed,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Workout',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${totalWorkout.toInt().toString()}',
                                                        style: TextStyle(
                                                          fontSize: 35,
                                                          color: AppColors
                                                              .appBlack,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Kcal',
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .appBlack,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.appRed,
                                              ),
                                            ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.40,
                              child: Column(
                                children: [
                                  Container(
                                    height: 70,
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.appRed,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[400]!,
                                            offset: Offset(0.0, 6.0),
                                            blurRadius: 8.0)
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                todayDate,
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: AppColors.appWhite,
                                                    fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                todayMonth,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.appWhite,
                                                    fontWeight: FontWeight.w500),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SvgPicture.asset('assets/calendar.svg',
                                            height: 35, width: 35),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AchievementSC()))
                                          .then((value) => _getUserDetails());
                                    },
                                    child: Container(
                                      height: 70,
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.appWhite,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[400]!,
                                              offset: Offset(0.0, 6.0),
                                              blurRadius: 8.0)
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Your',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColors.appBlack,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Text(
                                                  'Achievement',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColors.appBlack,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SvgPicture.asset(
                                              'assets/achievement.svg',
                                              height: 35,
                                              width: 35),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RepeatWorkoutSC()))
                                          .then((value) => _getUserDetails());
                                    },
                                    child: Container(
                                      height: 70,
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.appWhite,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[400]!,
                                              offset: Offset(0.0, 6.0),
                                              blurRadius: 8.0)
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Repeat',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColors.appBlack,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Text(
                                                  'Workout',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColors.appBlack,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SvgPicture.asset(
                                              'assets/repeatplay.svg',
                                              height: 35,
                                              width: 35),
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
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 20),
                        child: Text(
                          'Today Workout Activity Report',
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.appRed,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.appBg,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(top: 15),
                        height: 280,
                        child: (isLoadingWorkout == false)
                            ? Container(
                                child: (todayWorkoutList!.data!.isNotEmpty)
                                    ? Scrollbar(
                                        child: ListView.builder(
                                          itemCount:
                                              todayWorkoutList!.data!.length,
                                          itemBuilder: (context, index) {
                                            var data =
                                                todayWorkoutList!.data![index];
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            TodayWorkoutActivitySC(
                                                              workoutId: data
                                                                  .workoutId
                                                                  .toString(),
                                                              baseUrl:
                                                                  todayWorkoutList!
                                                                      .baseUrl,
                                                              workoutIcon: data
                                                                  .workoutIcon,
                                                            ),fullscreenDialog: true))
                                                    .then((value) =>
                                                        _getUserDetails());
                                              },
                                              child: Container(
                                                height: 60,
                                                margin: EdgeInsets.only(
                                                    bottom: 10, right: 8),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: AppColors.appWhite,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        color: Colors.black45,
                                                        width: 1)),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(8),
                                                      child: FancyShimmerImage(
                                                        imageUrl: '${todayWorkoutList!.baseUrl}${data.workoutIcon!}',
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
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppColors.appWhite,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/fire.svg',
                                                            height: 20,
                                                            width: 20,
                                                            color: AppColors
                                                                .appBlack,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            data.caloriesBurnt!,
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: AppColors
                                                                    .appRed,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                      )
                                    : Center(
                                        child: Text("No Record Found"),
                                      ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.appRed,
                                ),
                              ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 75,
                          width: 170,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(bottom: 20, top: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.appBlack,
                          ),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SearchSC()))
                                  .then((value) => _getUserDetails());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image(
                                  image: AssetImage('assets/Flogo.png'),
                                  height: 40,
                                  width: 40,
                                ),
                                Text(
                                  'Start\nWorkout',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.appWhite,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
