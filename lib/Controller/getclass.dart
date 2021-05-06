import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Getclasses extends GetxController {
  var subjects = ["1"];
  var zoomlinks;
  var zoompasswords;
  var availablesection = [];
  var timetablesubjects;
  String defaultsection;
  List<String> time = [
    "9:00 AM-10:00 AM",
    "10:00 AM-11:00 AM",
    "11:30 AM-12:30 PM",
    "12:30 PM-01:30 PM",
    "2:45 PM-03:45 PM"
  ];
  getsubjects({String course = "ECE", String section = "d"}) async {
    getpreference();
    try {
      var data;
      var firebase = FirebaseFirestore.instance;
      await firebase.collection("classes").doc("subjects").get().then((value) {
        data = value.data()[course][section];
      });
      subjects = data.keys.toList();
      //array of zoomlink ansd password eg:["link","paassword"]on index 0
      zoomlinks = data.values.toList();
      print(subjects);
      if (subjects.isEmpty) {
        subjects = ["0"];
      }
      update();
      return [subjects, zoomlinks];
    } catch (e) {
      print("Error while getting subjects and error is $e}");
    }
  }

  @override
  void onInit() async {
    // called immediately after the widget is allocated memory
    await getpreference();
    print("default is $defaultsection");
    getsubjects(section: defaultsection);
    gettimetable(section: defaultsection);
    super.onInit();
  }

  savepreference({String section}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    update();
    await prefs.setString('section', section);
    print("done");
  }

  Future<String> getpreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    defaultsection = prefs.getString('section');
    update();

    return defaultsection;
  }

  gettimetable({String course = "ECE", String section}) async {
    getpreference();

    var data;
    try {
      String day = DateTime.now().weekday.toString();
      print(day);

      var firebase = FirebaseFirestore.instance;
      await firebase.collection("classes").doc(course).get().then((value) {
        data = value.data()[section];
      });
      timetablesubjects = data[day];
      print(timetablesubjects);
      update();
      return timetablesubjects;
    } catch (e) {
      print("Error while getting timetable and error is $e}");
    }
  }

  // static getdatetimeday() {
  //   String day = DateTime.now().weekday.toString();
  //   List<String> daysinaweek = [
  //     "Monday",
  //     "Tuesday",
  //     "Wenesday",
  //     "Thrusday",
  //     "Friday"
  //   ];
  //   String date =
  //       "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

  //   String time = DateTime.now().hour.toString();
  //   print(date);
  //   print(time);
  // }
}
