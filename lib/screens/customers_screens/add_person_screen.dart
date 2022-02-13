import 'package:cashier/controllers/person_controller.dart';
import 'package:cashier/models/person_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPersonScreen extends StatelessWidget {
  AddPersonScreen({
    Key? key,
    this.person,
  }) : super(key: key);

  Person? person;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PersonController personController = Get.put(PersonController());
  DataBaseServices _dataBaseServices = DataBaseServices();

  String personName = 'name';
  String personPhone = 'phone';
  String personAddress = 'address';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة شخص'),
        centerTitle: true,
      ),
      bottomNavigationBar: CustomBottomAppBar(
        buttonText: 'حفظ',
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _dataBaseServices.addPerson(Person(
              id: personController.people.length + 1,
              name: personController.newPerson[personName],
              phoneNumber: personController.newPerson[personPhone] ?? '',
              address: personController.newPerson[personAddress] ?? '',
              type: 'عميل',
              bills: const [],
            ));
          }
        },
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                data: personName,
                value:  person?.name ?? '',
                hintText: 'إسم العميل ',
                textInputType: TextInputType.name,
                validatorHint: 'يجب إدخال إسم العميل',
                iconData: Icons.person,
                textMaxLength: 25,
                onChanged: (value) {
                  storingValue(value, personName);
                },
              ),
              CustomTextField(
                data: personPhone,
                value:  person?.phoneNumber ?? '',
                hintText: 'رقم الهاتف',
                textInputType: TextInputType.phone,
                iconData: Icons.phone,
                textMaxLength: 11,
                onChanged: (value) {
                  storingValue(value, personPhone);
                },
              ),
              CustomTextField(
                data: personAddress,
                value:  person?.address ?? '',
                hintText: 'العنوان',
                textInputType: TextInputType.streetAddress,
                iconData: Icons.location_city,
                textMaxLength: 50,
                onChanged: (value) {
                  storingValue(value, personAddress);
                },
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  storingValue(String value, String data) {
    personController.newPerson.update(
      data,
      (_) => value,
      ifAbsent: () => value,
    );
  }
}
