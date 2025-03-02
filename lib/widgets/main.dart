import 'package:Assignment3/widgets/productController.dart';
import 'package:Assignment3/widgets/product_card.dart';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(const CrudApp());
}

class CrudApp extends StatelessWidget {
  const CrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),

      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  final ProductController productController = ProductController();

  void _productDialog(
      {String? id,
      String? name,
      String? img,
      int? qty,
      int? unitPrice,
      int? totalPrice}) {
    TextEditingController productNameController =
        TextEditingController(text: name ?? '');
    TextEditingController productImageController =
        TextEditingController(text: img ?? '');
    TextEditingController productQtyController =
        TextEditingController(text: qty != null ? qty.toString() : '');
    TextEditingController productUnitPriceController = TextEditingController(
        text: unitPrice != null ? unitPrice.toString() : '');
    TextEditingController productTotalPriceController = TextEditingController(
        text: totalPrice != null ? totalPrice.toString() : '');

    void updateTotalPrice() {
      try {
        int qty = int.parse(productQtyController.text);
        int unitPrice = int.parse(productUnitPriceController.text);
        productTotalPriceController.text = (qty * unitPrice).toString();
      } catch (e) {
        productTotalPriceController.text = '0';
      }
    }

    productQtyController.addListener(updateTotalPrice);
    productUnitPriceController.addListener(updateTotalPrice);

    updateTotalPrice();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(id == null ? "Add Product" : "Update Product"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: productNameController,
                  decoration: InputDecoration(labelText: 'Product Name')),
              TextField(
                  controller: productImageController,
                  decoration: InputDecoration(labelText: 'Product Image URL')),
              TextField(
                  controller: productQtyController,
                  decoration: InputDecoration(labelText: 'Product Qty'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: productUnitPriceController,
                  decoration: InputDecoration(labelText: 'Unit Price'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: productTotalPriceController,
                  decoration: InputDecoration(labelText: 'Total Price'),
                  enabled: false),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel")),
                  SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await productController.createProduct(
                          productNameController.text,
                          productImageController.text,
                          int.parse(productQtyController.text),
                          int.parse(productUnitPriceController.text),
                          int.parse(productTotalPriceController.text),
                        );
                      } else {
                        await productController.updateProduct(
                          id,
                          productNameController.text,
                          productImageController.text,
                          int.parse(productQtyController.text),
                          int.parse(productUnitPriceController.text),
                          int.parse(productTotalPriceController.text),
                        );
                      }

                      await fetchData();

                      if (mounted) {
                        setState(() {});
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                    },
                    child: Text(
                      id == null ? "Add Product" : "Update Product",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    await productController.fetchProducts();
    setState(() {
      isLoading = false;
    });
  }

  void _confirmDelete(BuildContext context, int index, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure want to delete this product?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(index, id);
            },
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(int index, String id) {
    final deletedProduct = productController.products[index];

    productController.deleteProduct(id).then((value) {
      if (value) {
        setState(() {
          productController.products.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product deleted successfully!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: "Undo",
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  productController.products.insert(index, deletedProduct);
                });
              },
            ),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 80),
        child: isLoading
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6,
                ),
                itemCount: 6,
                itemBuilder: (context, index) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 200,
                    width: double.infinity,
                  ),
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6,
                ),
                itemCount: productController.products.length,
                itemBuilder: (context, index) {
                  var product = productController.products[index];
                  return ProductCard(
                    product: product,
                    onEdit: () => _productDialog(
                      id: product.sId,
                      name: product.productName,
                      img: product.img,
                      qty: product.qty,
                      unitPrice: product.unitPrice,
                    ),
                    onDelete: () =>
                        _confirmDelete(context, index, product.sId.toString()),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () => _productDialog(),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
