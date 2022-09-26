import 'package:get/get.dart';
import 'package:storewebgetx/memory/product.dart';
import 'package:storewebgetx/model/product.dart';

class ProductController extends GetxController with StateMixin {
  var count = 0.obs;
  RxBool isOpenDraw = true.obs;
  RxBool isCollapsed = false.obs;

  final _productList = <ProductModel>[].obs;
  RxList<ProductModel> get productList => _productList;
  RxList<ProductModel> selectedProduct = <ProductModel>[].obs;
  @override
  void onInit() async {
    super.onInit();
    await getData();
  }

  increment() => count++;
  setCollapsed(bool isColl) => isColl;

  getData() async {
    ProductProvider product = ProductProvider();
    final result = await product.getAllProducts();
    _productList.assignAll(result);
  }

  setAdd(product) {
    selectedProduct.add(product);
  }

  setRemove(product) {
    selectedProduct.remove(product);
  }

  int get totalPrice {
    int total = 0;
    selectedProduct.forEach((num) {
      total = total + num.price.toInt();
    });
    return total;
  }
}
