import 'package:shared_preferences/shared_preferences.dart';

class GetValues {

  Future<String> doGetAge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String age = prefs.getString('age')!;
    return age;
  }

  Future<String> doGetWeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String weight = prefs.getString('weight')!;
    return weight;
  }

  Future<String> doGetHeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String height = prefs.getString('height')!;
    return height;
  }

}