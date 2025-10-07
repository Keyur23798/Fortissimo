import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fortissimo/Screens/Login.dart';
import 'package:fortissimo/Utils/Utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'Home.dart';

class IntroSC extends StatefulWidget {
  const IntroSC({Key? key}) : super(key: key);

  @override
  _IntroSCState createState() => _IntroSCState();
}

class _IntroSCState extends State<IntroSC> {
  final controller = PageController(viewportFraction: 1, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
        3,
            (index) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade300,
          ),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Container(
            height: 150,
            child: Center(
                child: Text(
                  "Page $index",
                  style: TextStyle(color: AppColors.appRed),
                )),
          ),
        ));

    return Scaffold(
      backgroundColor: AppColors.appBlack,
      body: Stack(
        children: [
          ListView.builder(
            itemCount: 3,
            scrollDirection: Axis.horizontal,
            controller: controller,
            physics: PageScrollPhysics(),
            itemBuilder: (context,index){
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Opacity(
                      child: Image(
                        image: AssetImage('assets/intro${index+1}.jpg'),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                      opacity: 0.8,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Image(image: AssetImage('assets/logoBlackRed.png'),height: 80,width: 180,),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 80),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: (index == 0) ?
                        Container(
                          margin: EdgeInsets.only(left: 25,right: 25),
                          padding: EdgeInsets.all(15),
                          height: 200,
                          decoration: BoxDecoration(
                              color: AppColors.appBlack.withAlpha(100),
                              borderRadius: BorderRadius.circular(35)),
                          child: Column(
                            children: [
                              Text(
                                'Welcome\nto Fortissimo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 3),
                                child: Text(
                                  'Fortissimo has workouts on demand that you can find based on how much time you have',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  'Swipe to Get Started',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: AppColors.appRed,
                                      fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text:
                                      'Already have account? ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        decoration: TextDecoration.none,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: ' Sign In',
                                            style: TextStyle(
                                              color: AppColors.appRed,
                                              fontSize: 15,
                                              decoration:
                                              TextDecoration.none,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginSC()));
                                              }),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ) : (index == 1) ?
                        Container(
                          margin: EdgeInsets.only(left: 25,right: 25),
                          padding: EdgeInsets.all(15),
                          height: 150,
                          decoration: BoxDecoration(
                              color: AppColors.appBlack.withAlpha(100),
                              borderRadius: BorderRadius.circular(35)),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 3),
                                child: Text(
                                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                height: 45,
                                padding: EdgeInsets.only(left: 20, right: 20),
                                margin: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: AppColors.appRed,
                                ),
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginSC()));
                                  },
                                  child: Text(
                                    'Skip',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ) :
                        Container(
                          margin: EdgeInsets.only(left: 25,right: 25),
                          padding: EdgeInsets.all(15),
                          height: 150,
                          decoration: BoxDecoration(
                              color: AppColors.appBlack.withAlpha(100),
                              borderRadius: BorderRadius.circular(35)),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 3),
                                child: Text(
                                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                height: 45,
                                padding: EdgeInsets.only(left: 20, right: 20),
                                margin: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: AppColors.appRed,
                                ),
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginSC()));
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 5,
            left: (MediaQuery.of(context).size.width-(18*3))/2,
            child: Container(
              child: SmoothPageIndicator(
                controller: controller,
                count: pages.length,
                effect: SwapEffect(
                  dotHeight: 10,
                  activeDotColor: AppColors.appRed,
                  dotColor: AppColors.appBlack,
                  dotWidth: 10,
                  type: SwapType.yRotation,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
