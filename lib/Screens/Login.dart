import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortissimo/ApiHelper/ApiHelper.dart';
import 'package:fortissimo/Screens/Home.dart';
import 'package:fortissimo/Screens/Profile.dart';
import 'package:fortissimo/Utils/Utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CompanyProfile.dart';

class LoginSC extends StatefulWidget {
  const LoginSC({Key? key}) : super(key: key);

  @override
  _LoginSCState createState() => _LoginSCState();
}

class _LoginSCState extends State<LoginSC> {
  Utils utils = Utils();
  bool isLoggedIn = false;
  String deviceToken = '';

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  @override
  void initState() {
    super.initState();
    _generateToken();
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

  _login(BuildContext context, String email, String name, String type,String profilePic) async {
    final response = await ApiHelper().login(email, type,deviceToken);
    if (response.status == 1) {
      Fluttertoast.showToast(
          msg: 'Login successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[350],
          textColor: Colors.black,
          fontSize: 16.0);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('loginType', response.data!.first.loginType.toString());
      prefs.setString('userName', response.data!.first.name.toString());
      prefs.setString('email', response.data!.first.email.toString());
      prefs.setString('id', response.data!.first.id.toString());
      prefs.setString('deviceToken', response.data!.first.deviceToken.toString());
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
      prefs.setString('workoutGoal', response.data!.first.workoutGoal.toString());

      Fluttertoast.showToast(
          msg: "Login Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomeSC()));
    } else {
      Fluttertoast.showToast(
          msg: "Please Register First",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
      if(type == "Facebook"){
        String profile  = "http://graph.facebook.com/$profilePic/picture?type=large&redirect=true&width=500&height=500";
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => ProfileSC(
              name: name,
              email: email,
              from: "Facebook",
              profilePic: profile,
            )));

      }else{

        if(profilePic == "" || profilePic.isEmpty){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => ProfileSC(
                name: name,
                email: email,
                from: "Google",
                profilePic: "",
              )));
        }else{
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => ProfileSC(
                name: name,
                email: email,
                from: "Google",
                profilePic:profilePic,
              )));
        }

      }
    }
  }

  fbLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult = await facebookLogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    print("FacebookDetails- " + facebookLoginResult.status.toString());
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        print("FacebookStatus" +
            facebookLoginResult.error!.developerMessage.toString());
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancel:
        print("CancelledByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.success:
        print("LoggedIn");

        final profile = await facebookLogin.getUserProfile();
        facebookLogin
            .getUserEmail()
            .then((value) => {
                  if (value == null)
                    {ErrorToast(facebookLogin)}
                  else
                    {
                      _login(
                          context,
                          value.toString(),
                          profile!.firstName.toString() +
                              " " +
                              profile.lastName.toString(),
                          "Facebook",
                          profile.userId)
                    }
                })
            .catchError((e) {
          Fluttertoast.showToast(
              msg: "error",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey[350],
              textColor: Colors.black,
              fontSize: 16.0);
        }); // Future completes with someObject

        onLoginStatusChanged(true);
        break;
    }
  }

  onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  ErrorToast(FacebookLogin facebookLogin) {
    facebookLogin.logOut();
    Fluttertoast.showToast(
        msg: "Please use another id with email address",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[350],
        textColor: Colors.red,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBlack,
      body: Stack(
        children: [
          Image(
            image: AssetImage('assets/loginBg.jpg'),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: Align(
              alignment: Alignment.topCenter,
              child: Image(
                image: AssetImage('assets/logoBlackRed.png'),
                height: 80,
                width: 180,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 80),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(left: 25, right: 25),
                padding: EdgeInsets.all(20),
                height: Platform.isIOS ? 235 : 175,
                decoration: BoxDecoration(
                    color: AppColors.appBlack.withAlpha(100),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 0),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xff0079fb),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          fbLogin();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 15,
                              child: SvgPicture.asset('assets/facebook.svg',
                                  height: 18, width: 18),
                            ),
                            Text(
                              'Login with Facebook',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              width: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 0),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: FlatButton(
                        onPressed: () {
                          _googleSignIn.signIn().then((userData) {
                            if (userData!.email != '' &&
                                userData.displayName != '') {
                              utils.progressDialogue(context);
                              _login(context, userData.email.toString(),
                                  userData.displayName.toString(), "Google",userData.photoUrl.toString());
                            }
                          }).catchError((e) {
                            Fluttertoast.showToast(
                                msg: e.toString(),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey[350],
                                textColor: Colors.black,
                                fontSize: 16.0);
                            print("googleSignError" + e.toString());
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 15,
                              child: SvgPicture.asset('assets/google.svg',
                                  height: 18, width: 18),
                            ),
                            Text(
                              'Login with Google',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              width: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: Platform.isIOS ? true : false,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 0),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.black,
                        ),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileSC()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: SvgPicture.asset('assets/apple.svg',
                                    height: 18, width: 18),
                              ),
                              Text(
                                'SignIn with Apple',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                width: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'By signing up, you are agree with our ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            decoration: TextDecoration.none,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Terms & Conditions',
                                style: TextStyle(
                                  color: AppColors.appRed,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CompanyProfileSC(type:"Terms & Conditions")));
                                  }),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
