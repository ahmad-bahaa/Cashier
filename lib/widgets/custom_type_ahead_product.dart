import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/services/tasks.dart';
import 'package:cashier/widgets/build_new_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomTypeAheadProduct extends StatelessWidget {
  CustomTypeAheadProduct({
    Key? key,
    required this.typeAheadController,
    required this.productController,
    required this.billController,
    required this.isCelling,
  }) : super(key: key);
  final DataBaseServices dataBaseServices = DataBaseServices();
  final TextEditingController typeAheadController;
  final ProductController productController;
  final BillController billController;
  final bool isCelling;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TypeAheadFormField<Product>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: typeAheadController,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            decoration: InputDecoration(
              label: const Text('اسم الصنف'),
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
                child: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
          suggestionsCallback: (pattern) async {
            billController.product.update(
              'name',
                  (_) => pattern,
              ifAbsent: () => pattern,
            );
            return await dataBaseServices.queryAllProducts(pattern);
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              // leading: Text(suggestion.id.toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(' الكمية :  ${suggestion.quantity.toString()}'),
                ],
              ),
              title: Center(child: Text(suggestion.name)),
            );
          },
          onSuggestionSelected: (suggestion) {
            typeAheadController.text = suggestion.name;
            storingValue(suggestion.quantity.toString(), 'data');
            billController.product.update(
              'id',
              (_) => suggestion.id,
              ifAbsent: () => suggestion.id,
            );
            updatingProduct('name', suggestion.name);
            updatingProduct('quantity', suggestion.quantity.toString());
            updatingProduct(
                isCelling ? 'cellPrice' : 'buyPrice',
                isCelling
                    ? suggestion.cellPrice.toString()
                    : suggestion.buyPrice.toString());
            updatingProduct('billQuantity', '0');
            updatingProduct(
                isCelling ? 'billCellPrice' : 'billBuyPrice',
                isCelling
                    ? suggestion.cellPrice.toString()
                    : suggestion.buyPrice.toString());
            Tasks().showAction(
              context,
              isCelling ? 4 : 5,
            );
          },
          noItemsFoundBuilder: (context) {
            return const BuildNewItem(i: 3, text: 'إضافة صنف جديد');
          },
        ),
      ),
    );
  }

  storingValue(String value, String data) {
    productController.item.update(
      data,
      (_) => value,
      ifAbsent: () => value,
    );
  }

  updatingProduct(String data, String value) {
    billController.product.update(
      data,
      (_) => value,
      ifAbsent: () => value,
    );
  }
}
