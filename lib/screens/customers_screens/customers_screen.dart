import 'package:cashier/controllers/person_controller.dart';
import 'package:cashier/models/person_model.dart';
import 'package:cashier/screens/customers_screens/add_person_screen.dart';
import 'package:cashier/services/tasks.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class CustomersScreen extends StatelessWidget {
  CustomersScreen({Key? key}) : super(key: key);
  PersonController personController = Get.put(PersonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'قائمة العملاء',
      ),
      bottomNavigationBar: CustomBottomAppBar(
        buttonText: 'تسجيل عميل جديد',
        onPressed: () {
          Get.to(() => AddPersonScreen());
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  itemCount: personController.people.length,
                  itemBuilder: (context, index) {
                    Person person = personController.people[index];

                    return Container(
                      margin: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0.0, 1.0),
                            blurRadius: 4.0,
                            blurStyle: BlurStyle.normal,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () => Get.to(() => AddPersonScreen(
                                person: person,
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (person.phoneNumber.length < 11) {
                                        Tasks().showAction(context, 4);
                                      } else {
                                        UrlLauncher.launch(
                                            "tel://${person.phoneNumber.toString()}");
                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.phone,
                                        size: 25,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    person.phoneNumber,
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        person.name,
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        person.address,
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 25,
                                    child: Text(
                                      person.id.toString(),
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
