import 'package:cashier/models/product_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  DataBaseServices dataBaseServices = DataBaseServices();
  var newProduct = {}.obs;
  var products = <Product>[].obs;
  var activeProducts = <Product>[].obs;
  var endedProducts = <Product>[].obs;
  var item = {}.obs;

  @override
  void onInit() {
    products.bindStream(dataBaseServices.getAllProducts());
    activeProducts.bindStream(dataBaseServices.getAllActiveProducts());
    endedProducts.bindStream(dataBaseServices.getAllEndedProducts());
    super.onInit();
  }
}
