import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/controllers/person_controller.dart';
import 'package:cashier/models/person_model.dart';
import 'package:cashier/screens/customer_report_screens/customer_reports_screen.dart';
import 'package:cashier/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'build_new_item.dart';

class CustomTypeAheadPerson extends StatelessWidget {
  CustomTypeAheadPerson({
    Key? key,
    required this.typeAheadController,
    required this.billController,
    required this.isBill,
    required this.isEnabled,
  }) : super(key: key);
  final TextEditingController typeAheadController;
  final DataBaseServices dataBaseServices = DataBaseServices();
  final BillController billController;
  final PersonController personController = Get.put(PersonController());
  final bool isEnabled;
  final bool isBill;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TypeAheadField<Person>(
          textFieldConfiguration: TextFieldConfiguration(
            enabled: isEnabled,
            controller: typeAheadController,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            decoration: InputDecoration(
              label: const Text('اسم العميل'),
              labelStyle: const TextStyle(
                color: Colors.blue,
              ),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 3,
                ),
              ),
              prefixIcon: IconTheme(
                data: IconThemeData(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Icon(Icons.person),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  typeAheadController.clear();
                },
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
          suggestionsCallback: (pattern) async {
            personController.newPerson.update(
              'name',
              (_) => pattern,
              ifAbsent: () => pattern,
            );
            return await dataBaseServices.queryAllPeople(pattern);
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              // leading: Text(suggestion.id.toString()),
              trailing: const Icon(Icons.person),
              title: Center(child: Text(suggestion.name)),
            );
          },
          onSuggestionSelected: (suggestion) async {
            if (isBill) {
              typeAheadController.text = suggestion.name;
              billController.newBill.update(
                'name',
                (_) => suggestion.name,
                ifAbsent: () => suggestion.name,
              );
              billController.newBill.update(
                'uid',
                    (_) => suggestion.id,
                ifAbsent: () => suggestion.id,
              );
              billController.newBill.update(
                'personId',
                    (_) => suggestion.id,
                ifAbsent: () => suggestion.id,
              );
            } else {
              billController.newBill.update(
                'uid',
                    (_) => suggestion.id,
                ifAbsent: () => suggestion.id,
              );
              Get.to(() => const CustomerBillsScreen());
            }
          },
          noItemsFoundBuilder: (context) {
            return const BuildNewItem(i: 2, text: 'إضافة عميل جديد');
          },
        ),
      ),
    );
  }
}
