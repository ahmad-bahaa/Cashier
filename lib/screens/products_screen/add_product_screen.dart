import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/screens/products_screen/stock_screen.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/services/tasks.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({
    Key? key,
    this.product,
  }) : super(key: key);

  Product? product;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProductController productController = Get.put(ProductController());

  final DataBaseServices _dataBaseServices = DataBaseServices();

  final TextEditingController textEditingController = TextEditingController();

  final TextEditingController buyPriceTextEditingController =
      TextEditingController();

  final TextEditingController cellPriceTextEditingController =
      TextEditingController();

  String productName = 'name';

  String productCellPrice = 'cellPrice';

  String productBuyPrice = 'buyPrice';

  String productQuantity = 'quantity';

  int buyPriceData = 0;
  int cellPriceData = 0;
  String buttonText = 'تعديل';

  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    widget.product != null ? null : isEnabled = true;

    if (widget.product != null) {
      textEditingController.text = widget.product!.name.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product != null ? 'عرض صنف' : 'إضافة صنف'),
        centerTitle: true,
      ),
      bottomNavigationBar: CustomBottomAppBar(
        buttonText: widget.product != null ? buttonText : 'حفظ',
        onPressed: () {
          if (_formKey.currentState!.validate() && widget.product == null) {
            int id = productController.products.length + 1;
            double cellPrice =
            double.parse(productController.newProduct['cellPrice'] ?? '0.0');
            double buyPrice =
            double.parse(productController.newProduct['buyPrice'] ?? '0.0');
            int quantity =
                int.parse(productController.newProduct['quantity'] ?? '0');
            double lastPrice = productController.newProduct['lastPrice'] ?? 0.0;
            _dataBaseServices.addProduct(Product(
              id: id,
              name: productController.newProduct['name'],
              buyPrice: buyPrice,
              cellPrice: cellPrice,
              quantity: quantity,
              lastPrice: lastPrice,
            ));
            productController.newProduct.clear();
            textEditingController.clear();
            buyPriceTextEditingController.clear();
            cellPriceTextEditingController.clear();
            Tasks().showSuccessMessage(
                'عملية ناجحة', 'تم إاضافة صنف إلى قاعدة البيانات');
          } else if (widget.product != null && isEnabled) {
            //TODO edit the product info
            if (buyPriceData != 0 || cellPriceData != 0) {
              if (buyPriceData != 0) {
                _dataBaseServices.updateProductPrice(
                  'products',
                  widget.product!.id,
                  'buyPrice',
                  buyPriceData,
                );
              }
              if (cellPriceData != 0) {
                _dataBaseServices.updateProductPrice(
                  'products',
                  widget.product!.id,
                  'cellPrice',
                  cellPriceData,
                );
              }
              Tasks().showSuccessMessage(
                  'عملية ناجحة', 'تم تعديل بيانات الصنف في قاعدة البيانات');
              Get.offAll(() => const StockScreen());
            }
            setState(() {
              isEnabled = false;
              buttonText = 'تعديل';
            });
          } else if (widget.product != null && !isEnabled) {
            setState(() {
              isEnabled = true;
              buttonText = 'حفظ';
            });
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
                  isEnabled: widget.product != null ? false : true,
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
                  value: widget.product?.buyPrice.toString() ?? '',
                  isEnabled: isEnabled,
                  hintText: 'سعر الشراء',
                  textInputType: TextInputType.number,
                  iconData: Icons.money,
                  textMaxLength: 4,
                  onChanged: (value) {
                    widget.product != null
                        ? buyPriceData = int.parse(value)
                        : storingData(value, productBuyPrice);
                  },
                ),
                CustomTextField(
                  controller: cellPriceTextEditingController,
                  data: productCellPrice,
                  value: widget.product?.cellPrice.toString() ?? '',
                  isEnabled: isEnabled,
                  hintText: 'سعر البيع',
                  textInputType: TextInputType.number,
                  iconData: Icons.money,
                  textMaxLength: 4,
                  onChanged: (value) {
                    widget.product != null
                        ? cellPriceData = int.parse(value)
                        : storingData(value, productCellPrice);
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
