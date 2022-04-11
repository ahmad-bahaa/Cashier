import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/screens/products_screen/add_product_screen.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen({
    Key? key,
    required this.isFull,
  }) : super(key: key);
  ProductController productController = Get.put(ProductController());
  final bool isFull;

  @override
  Widget build(BuildContext context) {
    List<Product> cash =
    isFull ? productController.activeProducts: productController.endedProducts;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const RowUnitCard(
              name: 'اسم الصنف',
              quantity: 'الكمية',
              color: Colors.white54,
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount:cash.length,
                  itemBuilder: (context, index) {
                    Product product = cash[index];
                    return RowUnitCard(
                      name: product.name,
                      quantity: product.quantity.toString(),
                      color: product.quantity == 0
                          ? Colors.redAccent
                          : Colors.white,
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
