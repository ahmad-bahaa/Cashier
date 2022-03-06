import 'package:cashier/models/person_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:get/get.dart';

class PersonController extends GetxController {
  DataBaseServices dataBaseServices = DataBaseServices();
  var newPerson = {}.obs;
  var people = <Person>[].obs;
  var person = {}.obs;
  @override
  void onInit() {
    people.bindStream(dataBaseServices.getAllPeople());
    super.onInit();
  }
}
