import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortissimo/ApiHelper/ApiHelper.dart';
import 'package:fortissimo/Models/Notificationresponse.dart';
import 'package:fortissimo/Utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSC extends StatefulWidget {
  const NotificationSC({Key? key}) : super(key: key);

  @override
  _NotificationSCState createState() => _NotificationSCState();
}

class _NotificationSCState extends State<NotificationSC> {
  String userId = '';
  Notificationresponse? response;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _getUserDetails();
  }

  _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id') ?? '';

    _getNotification();
  }

  _getNotification() async {
    setState(() {
      isLoading = true;
    });
    response = await ApiHelper().getNotification();
    if (response!.status == 1) {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
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
                    'Notification',
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
              child: (isLoading == false) ?
              Container(
                padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                child: (response!.data!.isNotEmpty) ?
                ListView.builder(
                  itemCount: response!.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var data = response!.data![index];
                    return Container(
                      height: 70,
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: AppColors.appWhite,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: Colors.black45, width: 1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.title.toString(),
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Flexible(
                            child: Text(
                              data.message.toString(),
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ) :
                Center(
                  child: Text(
                    "No Records Found",
                    style: TextStyle(
                        fontSize: 15,
                        color: AppColors.appBlack,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
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
