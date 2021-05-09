import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:js' as js;

class Getclasses extends GetxController {
  var subjects = ["1"];
  var zoomlinks;
  var zoompasswords;
  var availablesection = [];
  String message;

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
    EasyLoading.show(status: "Loading");
    await getpreference();
    print(section);
    try {
      var data;
      var firebase = FirebaseFirestore.instance;
      await firebase.collection("classes").doc("subjects").get().then((value) {
        data = value.data()[course][section];
        message = value.data()["message"];
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
    EasyLoading.dismiss();
  }

  @override
  void onInit() async {
    // called immediately after the widget is allocated memory
    await getpreference();
    print("default is $defaultsection");
    getsubjects(section: defaultsection);
    gettimetable(section: defaultsection);
    checklogin();
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
    if (prefs.containsKey("section")) {
      defaultsection = prefs.getString('section');
    } else {
      defaultsection = 'a';
    }

    update();

    return defaultsection;
  }

  checklogin() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.id}'); // e.g. "Moto G (4)"

    FirebaseFirestore.instance.collection("users").doc("login").set({
      androidInfo.id: {
        "Device name": androidInfo.device,
        "time": DateTime.now(),
        "Device detailes": [
          androidInfo.androidId,
          androidInfo.board,
          androidInfo.brand,
          androidInfo.display,
        ],
      }
    }, SetOptions(merge: true));
  }

  gettimetable({String course = "ECE", String section}) async {
    EasyLoading.show(status: "Loading");
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
      EasyLoading.dismiss();
      return timetablesubjects;
    } catch (e) {
      print("Error while getting timetable and error is $e}");
      EasyLoading.dismiss();
    }
    print("dismisitn");
  }

  Future help() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'dev.vamsidhar@gmail.com',
      query: 'subject=EasyCliq Feedback&body=""', //add subject and body here
    );

    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchweb(String zoomlink, String password) async {
    print("it is web");

   await Clipboard.setData(ClipboardData(text: password));
    
    js.context.callMethod('open', [zoomlink]);
  }
}
