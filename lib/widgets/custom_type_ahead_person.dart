import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/models/person_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'build_new_item.dart';

class CustomTypeAheadPerson extends StatelessWidget {
  CustomTypeAheadPerson({
    Key? key,
    required this.typeAheadController,
    required this.billController,
  }) : super(key: key);
  final TextEditingController typeAheadController;
  final DataBaseServices dataBaseServices = DataBaseServices();
  final BillController billController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TypeAheadField<Person>(
          textFieldConfiguration: TextFieldConfiguration(
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
            ),
          ),
          suggestionsCallback: (pattern) async {
            return await dataBaseServices.queryAllPeople(pattern);
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              leading: Text(suggestion.id.toString()),
              trailing: const Icon(Icons.person),
              title: Center(child: Text(suggestion.name)),
            );
          },
          onSuggestionSelected: (suggestion) {
            typeAheadController.text = suggestion.name;
            billController.newBill.update(
              'name',
                  (_) => suggestion.name,
              ifAbsent: () => suggestion.name,
            );
          },
          noItemsFoundBuilder: (context) {
            return const BuildNewItem(i: 2, text: 'إضافة عميل جديد');
          },
        ),
      ),
    );
  }
}