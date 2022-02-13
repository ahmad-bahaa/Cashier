import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/controllers/person_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/person_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class AddBillScreen extends StatelessWidget {
  AddBillScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _billKey = GlobalKey<FormState>();

  ProductController productController = Get.put(ProductController());
  BillController billController = Get.put(BillController());
  PersonController personController = Get.put(PersonController());
  DataBaseServices dataBaseServices = DataBaseServices();

  @override
  Widget build(BuildContext context) {
    List<Person> people = personController.people;
    List<Product> items = productController.products;
    Person? person;
    Product? item;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة فاتورة'),
        centerTitle: true,
      ),
      bottomNavigationBar: CustomBottomAppBar(
        buttonText: 'اضافة فاتورة',
        onPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _billKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'اسم العميل',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TypeAheadField<Person>(
                      textFieldConfiguration: TextFieldConfiguration(
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
                        Get.snackbar('لقد تم اخيتار', suggestion.name);
                      },
                      noItemsFoundBuilder: (context) {
                        return InkWell(
                          onTap: ()=> Get.snackbar('سيتم اضافة عميل جديد', ' '),
                          child: SizedBox(
                            height: 100,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text('إضافة عميل جديد'),
                                  Icon(Icons.add),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Text(
                    'اسم الصنف',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  CustomTextFormField(
                      data: 'data',
                      hintText: 'اسم الصنف',
                      textInputType: TextInputType.name,
                      validatorHint: 'يجب إدخال اسم الصنف',
                      iconData: Icons.person,
                      textMaxLength: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text(
                        '9000',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue),
                      ),
                      Text(
                        'الاجمالي ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '9000',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue),
                      ),
                      Text(
                        'الكمية المتاحة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Icon(
                          Icons.download,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: CustomTextFormField(
                          data: 'data',
                          hintText: 'الكمية',
                          textInputType: TextInputType.name,
                          validatorHint: 'يجب إدخال الكمية',
                          iconData: Icons.person,
                          textMaxLength: 5,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: CustomTextFormField(
                          data: 'data',
                          hintText: 'سعر البيع',
                          textInputType: TextInputType.name,
                          validatorHint: 'يجب إدخال سعر البيع',
                          iconData: Icons.person,
                          textMaxLength: 5,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 2.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
