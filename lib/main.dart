import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storewebgetx/controller/controller.dart';
import 'package:storewebgetx/model/product.dart';

void main() {
  runApp(
    GetMaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          color: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final c c = Get.put(ProductController());

    return Scaffold(
      onDrawerChanged: (isOpened) {
        print(isOpened);
      },
      appBar: AppBar(),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollViewBody(),
    );
  }
}

class CustomScrollViewBody extends StatefulWidget {
  const CustomScrollViewBody({super.key});

  @override
  State<CustomScrollViewBody> createState() => _CustomScrollViewBodyState();
}

class _CustomScrollViewBodyState extends State<CustomScrollViewBody> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(() {});

    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        buildSliverAppHeader(context),
        BuildContainer(),
      ],
    );
  }

  // Header Appbar
  Widget buildSliverAppHeader(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      floating: true,
      // snap: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Container(
                width: 100.0,
                child: Text(
                  "Home",
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class BuildContainer extends GetView<ProductController> {
  const BuildContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // final c = Get.put(ProductController());
    final size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
      child: Row(
        children: [
          // Container(
          //   width: size.width,
          //   height: size.height,
          //   decoration: BoxDecoration(color: Colors.grey),
          // ),
          Expanded(child: TableBody()),

          Container(
            child: Column(
              children: [
                Container(
                  width: size.width * 0.2,
                  child: ListTile(
                    title: Obx((() => controller.selectedProduct.isNotEmpty
                        ? Text("Total: ${controller.totalPrice}")
                        : Text("Total: 0"))),
                  ),
                ),
                Container(
                  width: size.width * 0.2,
                  height: size.height,
                  child: Obx(
                    () => controller.selectedProduct.isNotEmpty
                        ? ListView.builder(
                            itemCount: controller.selectedProduct.length,
                            itemBuilder: ((context, index) {
                              return ListTile(
                                leading: Image.network(
                                  "${controller.selectedProduct[index].image}",
                                  height: 60.0,
                                  width: 60.0,
                                ),
                                title: Text(
                                    "${controller.selectedProduct[index].title}"),
                                subtitle: Text(
                                    "${controller.selectedProduct[index].price.toInt()}"),
                                trailing: IconButton(
                                  onPressed: () {
                                    controller.setRemove(
                                        controller.selectedProduct[index]);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              );
                            }),
                          )
                        : Container(
                            width: size.width * 0.2,
                            height: size.height,
                            child: Text("not data"),
                          ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TableBody extends GetView<ProductController> {
  TableBody({super.key});
  final c = Get.put(ProductController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          (() => DataTable(
                columns: getColumns(columns),
                // rows: getRows(c.productList),
                rows: getRows(controller.productList, context),
              )),
        )
      ],
    );
  }

  final columns = [
    'ID',
    'image',
    'price',
    'category',
    'rating',
    'title',
    'description'
  ];

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
          ))
      .toList();

  List<DataRow> getRows(List<ProductModel> product, context) => product
      .map((ProductModel product) => DataRow(
            selected: c.selectedProduct.contains(product),
            onLongPress: () {
              showModalBottomSheet(
                  context: context,
                  builder: ((context) {
                    return Container(
                        child: Column(
                      children: [Text("data here")],
                    ));
                  }));
            },
            onSelectChanged: (isSelected) {
              final isAdding = isSelected != null && isSelected;
              isAdding ? c.setAdd(product) : c.setRemove(product);
            },
            cells: [
              DataCell(Text("${product.id}")),
              DataCell(Image.network(
                "${product.image}",
                width: 60.0,
                height: 60.0,
              )),
              DataCell(Text("${product.price.toInt()}")),
              DataCell(Text("${product.category}")),
              DataCell(Text("${product.rating!.count.toInt()}")),
              DataCell(Text("${product.title}")),
              DataCell(Text("${product.description}")),
            ],
          ))
      .toList();
}
