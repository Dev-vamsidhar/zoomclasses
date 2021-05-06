import 'package:easyzoom/Controller/getclass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_select/smart_select.dart';
import 'package:url_launcher/url_launcher.dart';

class Allclasses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("ECE Online Classes"),
        ),
        body: GetBuilder<Getclasses>(
          init: Getclasses(),
          builder: (controller) {
            return Column(
              mainAxisAlignment: controller.subjects[0] != "0"
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                SmartSelect.single(
                    title: "Select your section",
                    modalType: S2ModalType.popupDialog,
                    placeholder: controller.defaultsection,
                    choiceItems: [
                      S2Choice<String>(value: 'A', title: 'A Section'),
                      S2Choice<String>(value: 'B', title: 'B Section'),
                      S2Choice<String>(value: 'C', title: 'C Section'),
                      S2Choice<String>(value: 'D', title: 'D Section'),
                    ],
                    value: "vamsidhar red",
                    onChange: (value) {
                      controller.getsubjects(
                          section: value.value.toString().toLowerCase());
                    }),
                controller.subjects[0] != "0"
                    ? Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: controller.subjects != null
                              ? controller.subjects.length
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
                                                  controller.subjects[index],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: RaisedButton(
                                            color: Colors.blueGrey,
                                            onPressed: () async {
                                              String zoomlink = controller
                                                  .zoomlinks[index][0];
                                              String password = controller
                                                  .zoomlinks[index][1];
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
                                            child:
                                                Text("Join and Copy Password"),
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
              ],
            );
          },
        ));
  }
}
