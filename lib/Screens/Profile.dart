import 'dart:io';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortissimo/ApiHelper/ApiHelper.dart';
import 'package:fortissimo/Screens/Home.dart';
import 'package:fortissimo/Utils/Utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ProfileSC extends StatefulWidget {
  // const ProfileSC({Key? key}) : super(key: key);

  String? name = "";
  String? email = "";
  String? from = "";
  String? profilePic = "";
  ProfileSC({this.name, this.email, this.from,this.profilePic});
  @override
  _ProfileSCState createState() => _ProfileSCState();
}

class _ProfileSCState extends State<ProfileSC> {

  String gender = 'Male';
  int weight = 0;
  String weightType = 'Kg';
  double height = 0;
  String heightType = 'Mt';
  String validate = '';
  String selected_date = 'Select Date';
  bool hideLblWeight = false;
  bool hideLblHeight = false;
  DateTime selectedDate = DateTime.now();
  Utils utils = Utils();
  File? _image;
  final picker = ImagePicker();
  String imageName = '';
  String imagePath = '';
  String imageUrl = '';
  String deviceToken = '';
  TextEditingController workoutController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _generateToken();
    if (widget.from == "Home") {
      getProfile();
    } else {
      if(widget.profilePic.toString().isEmpty || widget.profilePic == null){

      }else{
        setState(() {
          imageUrl = widget.profilePic.toString();
        });
      }
    }
  }

  _generateToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print('firebase token ----> '+token!);
    setState(() {
      deviceToken = token;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('deviceToken', token);
  }

  void getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('id');

    print("userId- " + userId.toString());

    final response = await ApiHelper().getProfile(userId!);
    if (response.status == 1) {
      setState(() {
        print("weightUser- " + response.data![0].weight.toString());
        int value = response.data![0].workoutGoal!;
        hideLblWeight = true;
        weightType = response.data![0].weightUnit!;
        weight = int.parse(response.data![0].weight!);
        workoutController.text = response.data![0].workoutGoal!.toString();
        height = double.parse(response.data![0].height!);
        heightType = response.data![0].heightUnit!;
        hideLblHeight = true;
        gender = response.data![0].gender!;
        selected_date = response.data![0].dateOfBirth!;
        if(response.data![0].profilePic!.isEmpty || response.data![0].profilePic == ""){
          String? get_imageUrl = prefs.getString('profilePicUrl');
          imageUrl = get_imageUrl!;
        }else{
          imageUrl = response.data![0].profilePic!;
        }

      });
    }
  }

  void editProfile(BuildContext context) async {
    utils.progressDialogue(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('id');
    print("userId- " + userId.toString());
    final response = await ApiHelper().editProfile(
        userId!,
        imagePath,
        gender,
        selected_date,
        height.toString(),
        heightType,
        weight.toString(),
        weightType,
        workoutController.text.toString(),
        imageUrl);
    if (response.status == 1) {
      prefs.setString('profilePic', response.data!.profilePic.toString());
      prefs.setString('dob', response.data!.dateOfBirth.toString());
      prefs.setString('gender', response.data!.gender.toString());
      prefs.setString('height', response.data!.height.toString());
      prefs.setString('heightUnit', response.data!.heightUnit.toString());
      prefs.setString('weight', response.data!.weight.toString());
      prefs.setString('weightUnit', response.data!.weightUnit.toString());
      prefs.setString('age', response.data!.age.toString());
      prefs.setString(
          'workoutGoal', response.data!.workoutGoal.toString());

      Fluttertoast.showToast(
          msg: "Successfully Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: response.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    }
  }

  void _register(BuildContext context) async {
    utils.progressDialogue(context);

    final response = await ApiHelper().register(
        widget.name.toString(),
        widget.email.toString(),
        deviceToken,
        widget.from.toString(),
        gender,
        height.toString(),
        heightType,
        selected_date,
        weight.toString(),
        weightType,
        imagePath,
        workoutController.text.toString(),
        imageUrl);
    if (response.status == 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('id', response.data!.first.id.toString());
      prefs.setString('loginType', response.data!.first.loginType.toString());
      prefs.setString('userName', response.data!.first.name.toString());
      prefs.setString('email', response.data!.first.email.toString());
      prefs.setString(
          'deviceToken', response.data!.first.deviceToken.toString());
      prefs.setString('baseUrl', response.baseUrl!);
      prefs.setString('apiToken', response.data!.first.apiToken.toString());
      prefs.setString('profilePic', response.data!.first.profilePic.toString());
      prefs.setString('profilePicUrl', response.data!.first.profile_pic_url.toString());
      prefs.setString('dob', response.data!.first.dateOfBirth.toString());
      prefs.setString('gender', response.data!.first.gender.toString());
      prefs.setString('height', response.data!.first.height.toString());
      prefs.setString('heightUnit', response.data!.first.heightUnit.toString());
      prefs.setString('weight', response.data!.first.weight.toString());
      prefs.setString('weightUnit', response.data!.first.weightUnit.toString());
      prefs.setString('age', response.data!.first.age.toString());
      prefs.setString(
          'workoutGoal', response.data!.first.workoutGoal.toString());

      Fluttertoast.showToast(
          msg: "Register Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomeSC()));
    } else {
      Fluttertoast.showToast(
          msg: response.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageUrl = '';
        _image = File(pickedFile.path);
        imageName = _image!.path.split('/').last;
        imagePath = pickedFile.path;
      });
    } else {
      print('No image selected.');
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageUrl = '';
        _image = File(pickedFile.path);
        imageName = _image!.path.split('/').last;
        imagePath = pickedFile.path;
      });
    } else {
      print('No image selected.');
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
                    'Profile',
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: AppColors.appRed,
                          child: ClipOval(
                            child: (imageUrl == "" && _image == null) ?
                            Image(image: AssetImage('assets/logoWhite.png'),) :
                            (_image == null) ?
                            FancyShimmerImage(
                              imageUrl: imageUrl,
                              height: 90,
                              width: 90,
                              boxFit: BoxFit.cover,) :
                            Image.file(
                              _image!,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 5,
                          top: 65,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: GestureDetector(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                color: Colors.black,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(top: 35, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[400]!,
                              offset: Offset(0.0, 6.0),
                              blurRadius: 8.0)
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Name',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.name.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Email',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.email.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date of Birth',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final DateTime selected = showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(1960),
                                    lastDate: DateTime(2025),
                                  ).then((pickedDate) {
                                    setState(() {
                                      var inputFormat = DateFormat('dd MMM yyyy');
                                      selected_date = inputFormat.format(pickedDate!);
                                    });
                                  }) as DateTime;
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: AppColors.appBg,
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Text(
                                    selected_date,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      padding:
                      EdgeInsets.only(right: 25, left: 25, bottom: 10, top: 10),
                      margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                            child: Text(
                              'Workout Goal :',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.appBlack,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: '0',
                                ),
                                controller: workoutController,
                                validator: (val) {
                                  if (val!.isEmpty || val.length == 0) {
                                    return 'Please enter valid value';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.all(10),
                      margin:
                      EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  gender = 'Male';
                                });
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: (gender == 'Male')
                                      ? AppColors.appRed
                                      : AppColors.appWhite,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Male',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: (gender == 'Male')
                                          ? AppColors.appWhite
                                          : AppColors.appBlack,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  gender = 'Female';
                                });
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: (gender == 'Female')
                                      ? AppColors.appRed
                                      : AppColors.appWhite,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Female',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: (gender == 'Female')
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
                    Container(
                      margin: EdgeInsets.only(bottom: 0, left: 30, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Weight',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.appRed,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 70,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  weightType,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                PopupMenuButton(
                                  icon: Icon(Icons.keyboard_arrow_down,
                                      color: AppColors.appRed),
                                  iconSize: 25,
                                  initialValue: weightType,
                                  itemBuilder: (_) => <PopupMenuItem<String>>[
                                    new PopupMenuItem<String>(
                                        child: const Text('Kg'), value: 'Kg'),
                                    new PopupMenuItem<String>(
                                        child: const Text('Lb'), value: 'Lb'),
                                  ],
                                  onSelected: (value) async {
                                    setState(() {
                                      weightType = '${value}';
                                    });
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      margin: EdgeInsets.only(left: 5, right: 5),
                      child: ListView.builder(
                        itemCount: 200,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(right: 5),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  weight = index + 1;
                                  hideLblWeight = true;
                                });
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: (weight == index + 1)
                                    ? AppColors.appRed
                                    : AppColors.appWhite,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: (weight == index + 1)
                                          ? AppColors.appWhite
                                          : AppColors.appBlack,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: hideLblWeight,
                      child: Text(
                        '$weight ${weightType}',
                        style: TextStyle(
                            fontSize: 18,
                            color: AppColors.appBlack,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 0, left: 30, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Height',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.appRed,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 75,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  heightType,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                PopupMenuButton(
                                  icon: Icon(Icons.keyboard_arrow_down,
                                      color: AppColors.appRed),
                                  iconSize: 25,
                                  initialValue: heightType,
                                  itemBuilder: (_) => <PopupMenuItem<String>>[
                                    new PopupMenuItem<String>(
                                        child: const Text('Cm'), value: 'Cm'),
                                    new PopupMenuItem<String>(
                                        child: const Text('Ft'), value: 'Ft'),
                                  ],
                                  onSelected: (value) async {
                                    setState(() {
                                      heightType = '${value}';
                                      height = 0;
                                    });
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: heightType == 'Cm' ? true : false,
                      child: SfSlider(
                        min: 0.0,
                        max: 300.0,
                        activeColor: AppColors.appRed,
                        inactiveColor: AppColors.appRed.withAlpha(50),
                        value: height,
                        interval: 25,
                        showTicks: true,
                        showLabels: true,
                        enableTooltip: true,
                        minorTicksPerInterval: 3,
                        onChanged: (dynamic value) {
                          double d = value;
                          setState(() {
                            height = d;
                            hideLblHeight = true;
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: heightType == 'Ft' ? true : false,
                      child: SfSlider(
                        min: 0,
                        max: 8,
                        activeColor: AppColors.appRed,
                        inactiveColor: AppColors.appRed.withAlpha(50),
                        value: height,
                        stepSize: 0.5,
                        interval: 0.5,
                        showTicks: true,
                        showLabels: true,
                        enableTooltip: true,
                        minorTicksPerInterval: 3,
                        onChanged: (dynamic value) {
                          double d = value;
                          setState(() {
                            height = d;
                            hideLblHeight = true;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Visibility(
                        visible: hideLblHeight,
                        child: Text(
                          '$height ${heightType}',
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.appBlack,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 0),
                      margin:
                      EdgeInsets.only(bottom: 10, top: 30, left: 40, right: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: AppColors.appRed,
                      ),
                      child: FlatButton(
                        onPressed: () {
                          if (widget.from == "Home") {
                            if (_formKey.currentState!.validate()) {
                              if(height > 0 && weight > 0){
                                editProfile(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please select height/weight",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please enter workout goal",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          } else {
                            if (_formKey.currentState!.validate()) {
                              if(height > 0 && weight > 0){
                                _register(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please select height/weight",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please enter workout goal",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          }
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}