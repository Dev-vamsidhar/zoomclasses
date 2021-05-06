import 'package:easyzoom/Controller/getclass.dart';
import 'package:easyzoom/Screens/allclasses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_select/smart_select.dart';

class Classes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("Today Classes"),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == "All Classes") {
                  Get.to(Allclasses());
                }
              },
              itemBuilder: (BuildContext context) {
                return {'All Classes', 'Help'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: GetBuilder<Getclasses>(
          init: Getclasses(),
          builder: (controller) {
            controller.getpreference();

            return Column(
                mainAxisAlignment: controller.subjects[0] != "0"
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  SmartSelect.single(
                      title: "Select your section",
                      modalType: S2ModalType.popupDialog,
                      choiceItems: [
                        S2Choice<String>(value: 'A', title: 'A Section'),
                        S2Choice<String>(value: 'B', title: 'B Section'),
                        S2Choice<String>(value: 'C', title: 'C Section'),
                        S2Choice<String>(value: 'D', title: 'D Section'),
                      ],
                      value: "",
                      placeholder: controller.defaultsection != null
                          ? controller.defaultsection.toUpperCase()
                          : controller.defaultsection,
                      onChange: (value) {
                        controller.savepreference(
                            section: value.value
                                .toString()
                                .removeAllWhitespace
                                .toLowerCase());
                        controller.gettimetable(
                            section: value.value.toString().toLowerCase());
                        controller.getsubjects(
                            section: value.value.toString().toLowerCase());
                      }),
                  controller.subjects[0] != "0"
                      ? Expanded(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: controller.timetablesubjects != null
                                ? controller.timetablesubjects.length
                                : 0,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 100000,
                                      child: Column(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: Get.width / 1.2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    controller
                                                            .timetablesubjects[
                                                        index],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Text(
                                                        controller.time[index]),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: RaisedButton(
                                              color: Colors.blueGrey,
                                              onPressed: () async {
                                                String zoomlink = controller
                                                        .zoomlinks[
                                                    controller.subjects
                                                        .toList()
                                                        .indexOf(controller
                                                                .timetablesubjects[
                                                            index])][0];
                                                String password = controller
                                                        .zoomlinks[
                                                    controller.subjects
                                                        .toList()
                                                        .indexOf(controller
                                                                .timetablesubjects[
                                                            index])][1];
                                                Clipboard.setData(ClipboardData(
                                                    text: password));
                                                print(zoomlink);
                                                print(password);
                                                await canLaunch(zoomlink
                                                        .removeAllWhitespace)
                                                    ? await launch(zoomlink
                                                        .removeAllWhitespace)
                                                    : throw 'Could not launch $zoomlink';
                                              },
                                              child: Text(
                                                  "Join and Copy Password"),
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                  if (index == 1) ...[
                                    Text("<<...Interval...>>")
                                  ] else if (index == 3) ...[
                                    Text("<<...Lunch Break...>>")
                                  ]
                                ],
                              );
                            },
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: Get.height / 3,
                            ),
                            Center(
                                child: Text(
                                    "Subjects are not yet saved for your section ")),
                          ],
                        ),
                ]);
          },
        ));
  }
}
