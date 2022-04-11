import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/services/tasks.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({
    Key? key,
    this.product,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ProductController productController = Get.put(ProductController());
  final DataBaseServices _dataBaseServices = DataBaseServices();
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController buyPriceTextEditingController = TextEditingController();
  final TextEditingController cellPriceTextEditingController = TextEditingController();

  String productName = 'name';
  String productCellPrice = 'cellPrice';
  String productBuyPrice = 'buyPrice';
  String productQuantity = 'quantity';
  Product? product;
  late bool isEnabled;

  @override
  Widget build(BuildContext context) {
    product != null ? isEnabled = false : isEnabled = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة صنف'),
        centerTitle: true,
      ),
      bottomNavigationBar: CustomBottomAppBar(
        buttonText: 'حفظ',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            int id = productController.products.length + 1;
            int cellPrice =
                int.parse(productController.newProduct['cellPrice'] ?? '0');
            int buyPrice =
                int.parse(productController.newProduct['buyPrice'] ?? '0');
            int quantity =
                int.parse(productController.newProduct['quantity'] ?? '0');
            _dataBaseServices.addProduct(Product(
              id: id,
              name: productController.newProduct['name'],
              buyPrice: buyPrice,
              cellPrice: cellPrice,
              quantity: quantity,
            ));
            productController.newProduct.clear();
            textEditingController.clear();
            Tasks().showSuccessMessage(
                'عملية ناجحة', 'تم إاضافة صنف إلى قاعدة البيانات');
          }
        },
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: textEditingController,
                  data: productName,
                  // value: product?.name ?? '',
                  isEnabled: isEnabled,
                  hintText: 'إسم الصنف ',
                  textInputType: TextInputType.name,
                  validatorHint: 'يجب إدخال إسم الصنف',
                  iconData: Icons.person,
                  textMaxLength: 20,
                  onChanged: (value) {
                    storingData(value, productName);
                  },
                ),
                CustomTextField(
                  controller: buyPriceTextEditingController,
                  data: productBuyPrice,
                  value: product?.buyPrice.toString() ?? '',
                  isEnabled: isEnabled,
                  hintText: 'سعر الشراء',
                  textInputType: TextInputType.number,
                  iconData: Icons.money,
                  textMaxLength: 4,
                  onChanged: (value) {
                    storingData(value, productBuyPrice);
                  },
                ),
                CustomTextField(
                  controller: cellPriceTextEditingController,
                  data: productCellPrice,
                  value: product?.cellPrice.toString() ?? '',
                  isEnabled: isEnabled,
                  hintText: 'سعر البيع',
                  textInputType: TextInputType.number,
                  iconData: Icons.money,
                  textMaxLength: 4,
                  onChanged: (value) {
                    storingData(value, productCellPrice);
                  },
                ),
                // CustomTextField(
                //   data: productQuantity,
                //   value: product?.quantity.toString() ?? '',
                //   isEnabled: isEnabled,
                //   hintText: 'الكمية',
                //   textInputType: TextInputType.number,
                //   iconData: Icons.add_shopping_cart_outlined,
                //   textMaxLength: 4,
                //   onChanged: (value) {
                //     storingData(value, productQuantity);
                //   },
                // ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  storingData(String value, String data) {
    productController.newProduct.update(
      data,
      (_) => value,
      ifAbsent: () => value,
    );
  }
}
