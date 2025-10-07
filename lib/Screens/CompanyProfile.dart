import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../ApiHelper/ApiHelper.dart';
import '../Utils/Utils.dart';

class CompanyProfileSC extends StatefulWidget {
  // const CompanyProfile({Key? key}) : super(key: key);
  String? type;
  CompanyProfileSC({this.type});

  @override
  _CompanyProfileSCState createState() => _CompanyProfileSCState();
}

class _CompanyProfileSCState extends State<CompanyProfileSC> {
  String info = "";

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  void getProfile() async{
    final response = await ApiHelper().companyProfile();
    if (response.status == 1) {
      print("responseComp"+response.data.toString());
      if(widget.type =="Terms & Conditions"){
        setState(() {
          info = response.data![0].termsConditions.toString();
        });
      }else if(widget.type =="Privacy Policy"){
        setState(() {
          info = response.data![0].privacyPolicy.toString();
        });
      }else{
        setState(() {
          info = response.data![0].aboutUs.toString();
        });
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
                    widget.type!,
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
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: info.isEmpty ?
                  Container() :
                  Container(
                    child: Html(data: info,),
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

