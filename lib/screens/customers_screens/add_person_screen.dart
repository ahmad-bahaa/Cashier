import 'package:cashier/controllers/person_controller.dart';
import 'package:cashier/models/person_model.dart';
import 'package:cashier/screens/customers_screens/customers_screen.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/services/tasks.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPersonScreen extends StatefulWidget {
  AddPersonScreen({
    Key? key,
    this.person,
  }) : super(key: key);

  Person? person;

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PersonController personController = Get.put(PersonController());

  final DataBaseServices _dataBaseServices = DataBaseServices();

  final TextEditingController nameTextEditingController =
      TextEditingController();

  final TextEditingController addressTextEditingController =
      TextEditingController();

  final TextEditingController phoneTextEditingController =
      TextEditingController();

  String personName = 'name';

  String personPhone = 'phone';

  String phoneData = '';

  String addressData = '';

  String personAddress = 'address';

  String buttonText = 'تعديل';

  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    widget.person != null ? null : isEnabled = true;
    if (widget.person != null) {
      // isEnabled = false;
      nameTextEditingController.text = widget.person!.name.toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة شخص'),
        centerTitle: true,
      ),
      bottomNavigationBar: CustomBottomAppBar(
        buttonText: widget.person != null ? buttonText : 'حفظ',
        onPressed: () async {
          if (_formKey.currentState!.validate() && widget.person == null) {
            _dataBaseServices.addPerson(Person(
              id: personController.people.length + 1,
              name: personController.newPerson[personName],
              phoneNumber: personController.newPerson[personPhone] ?? '',
              address: personController.newPerson[personAddress] ?? '',
              type: 'عميل',
              paid: 0,
              owned: 0,
            ));
            personController.newPerson.clear();
            nameTextEditingController.clear();
            Tasks().showSuccessMessage(
                'عملية ناجحة', 'تم إاضافة عميل إلى قاعدة البيانات');
          } else if (widget.person != null && isEnabled) {
            if (phoneData != '' || addressData != '') {
              if (phoneData != '') {
                _dataBaseServices.updatePersonInfo(
                  'people',
                  widget.person!.id,
                  'phoneNumber',
                  phoneData,
                );
              }
              if (addressData != '') {
                _dataBaseServices.updatePersonInfo(
                  'people',
                  widget.person!.id,
                  'address',
                  addressData,
                );
              }
              Tasks().showSuccessMessage(
                  'عملية ناجحة', 'تم تعديل بيانات العميل في قاعدة البيانات');
              Get.offAll(() => CustomersScreen());
            }
            setState(() {
              isEnabled = false;
              buttonText = 'تعديل';
            });
          } else if (widget.person != null && !isEnabled) {
            setState(() {
              isEnabled = true;
              buttonText = 'حفظ';
            });
          }
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: nameTextEditingController,
                  data: personName,
                  value: widget.person?.name ?? '',
                  isEnabled: widget.person != null ? false : true,
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
                  controller: phoneTextEditingController,
                  data: personPhone,
                  value: widget.person?.phoneNumber ?? '',
                  isEnabled: isEnabled,
                  hintText: 'رقم الهاتف',
                  textInputType: TextInputType.phone,
                  iconData: Icons.phone,
                  textMaxLength: 11,
                  onChanged: (value) {
                    widget.person != null
                        ? phoneData = value
                        : storingValue(value, personPhone);
                  },
                ),
                CustomTextField(
                  controller: addressTextEditingController,
                  data: personAddress,
                  value: widget.person?.address ?? '',
                  isEnabled: isEnabled,
                  hintText: 'العنوان',
                  textInputType: TextInputType.streetAddress,
                  iconData: Icons.location_city,
                  textMaxLength: 50,
                  onChanged: (value) {
                    widget.person != null
                        ? addressData = value
                        : storingValue(value, personAddress);
                  },
                ),
                const SizedBox(),
              ],
            ),
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
