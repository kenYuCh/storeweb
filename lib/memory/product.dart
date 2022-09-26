import 'dart:convert';

import 'package:get/get.dart';

import 'package:storewebgetx/model/product.dart';

class ProductProvider extends GetConnect {
  List<ProductModel> result = [];
  // Get request
  Future<List<ProductModel>> getAllProducts() async {
    final response = await get('https://fakestoreapi.com/products');
    final jsonString = jsonEncode(response.body);
    final jsonArray = jsonDecode(jsonString) as List;
    result = jsonArray.map((e) => ProductModel.fromJson(e)).toList();
    return result;
  }
}

// class ProductMemo {
//   List<ProductModel> result = [];
//   ProductMemo() {
//     initCatalogs();
//   }
//   Future initCatalogs() async {
//     result.clear();
//   }

//   Future<List<ProductModel>> getAllProducts() async {
//     final response = await dio.get("https://fakestoreapi.com/products");
//     final jsonString = jsonEncode(response.data);
//     final jsonArray = jsonDecode(jsonString) as List;
//     result = jsonArray.map((e) => ProductModel.fromJson(e)).toList();
//     // print(jsonEncode(result[0]));
//     return result;
//   }

//   Future getSigleProducts(int id) async {
//     final response = await dio.get("https://fakestoreapi.com/products/${id}");
//     final jsonString = jsonEncode(response.data);
//     final jsonArray = jsonDecode(jsonString);
//     // print(jsonEncode(jsonArray)); // {"id":1}
//     return jsonArray;
//   }

//   Future<List<ProductModel>> getLimitProducts(int limit) async {
//     final response =
//         await dio.get("https://fakestoreapi.com/products?limit=${limit}");
//     final jsonString = jsonEncode(response.data);
//     final jsonArray = jsonDecode(jsonString) as List;
//     result = jsonArray.map((e) => ProductModel.fromJson(e)).toList();
//     // print(result);
//     return result;
//   }

//   Future<List<ProductModel>> getProductsSort(String sort) async {
//     final response =
//         await dio.get("https://fakestoreapi.com/products?sort=${sort}");
//     final jsonString = jsonEncode(response.data);
//     final jsonArray = jsonDecode(jsonString) as List;
//     result = jsonArray.map((e) => ProductModel.fromJson(e)).toList();
//     // print(result);
//     return result;
//   }

//   Future<List<ProductModel>> getCategory() async {
//     final response =
//         await dio.get("https://fakestoreapi.com/products/categories");
//     final jsonString = jsonEncode(response.data);
//     final jsonArray = jsonDecode(jsonString) as List;
//     result = jsonArray.map((e) => ProductModel.fromJson(e)).toList();
//     // print(result);
//     return result;
//   }

//   Future<List<ProductModel>> getSpecificCategory(String category) async {
//     final response =
//         await dio.get("https://fakestoreapi.com/products/category/${category}");
//     final jsonString = jsonEncode(response.data);
//     final jsonArray = jsonDecode(jsonString) as List;
//     result = jsonArray.map((e) => ProductModel.fromJson(e)).toList();
//     // print(jsonEncode(result));
//     return result;
//   }

// //

//   addNewProduct() async {
//     final response = await dio.post(
//       "https://fakestoreapi.com/products",
//       queryParameters: {
//         'title': 'test product',
//         'price': 13.5,
//         'description': 'lorem ipsum set',
//         'image': 'https://i.pravatar.cc',
//         'category': 'electronic'
//       },
//     );
//     final resultData = await getAllProducts();
//     return resultData.length; // 回傳資料筆數
//   }

//   void updateProduct(int id) async {
//     final response = await dio.put(
//       "https://fakestoreapi.com/products/${id}",
//       queryParameters: {
//         'title': 'test product',
//         'price': 13.5,
//         'description': 'lorem ipsum set',
//         'image': 'https://i.pravatar.cc',
//         'category': 'electronic'
//       },
//     );
//   }

//   void deleteProduct(int id) async {
//     final response = await dio.delete(
//       "https://fakestoreapi.com/products/${id}",
//     );
//   }

//   final APIkey = "Uv5NW5gkygwBrQ9eNihR67md";
//   removeBackground() async {
//     FormData formData = FormData.fromMap({
//       "size": "auto",
//       "image_url": "https://www.remove.bg/example.jpg",
//     });
//     formData.files.addAll({});
//     final response = await dio.post(
//       "https://api.remove.bg/v1.0/removebg",
//       data: formData,
//       options: Options(
//         headers: {
//           'X-Api-Key': '${APIkey}',
//         },
//       ),
//     );
//     print(response.statusMessage);
//     // var raf = await file.openSync(mode: FileMode.write);
//     // raf.writeFromSync(response.data);
//     // await raf.close();
//     // print("down");
//     // File file = File("/Users/yuhsienchang/Documents/flutter_project202209/");
//     // final img = file.openSync(mode: FileMode.write);
//     // img.writeFromSync(response.data);
//     // await img.close();
//   }
// }

// /*
// curl -H 'X-API-Key: Uv5NW5gkygwBrQ9eNihR67md'           \
//        -F 'image_url=https://www.remove.bg/example.jpg'   \
//        -F 'size=auto'                                     \
//        -f https://api.remove.bg/v1.0/removebg -o no-bg.png

// */
