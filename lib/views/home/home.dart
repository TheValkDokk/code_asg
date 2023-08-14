import 'package:code_asg/models/product.dart';
import 'package:code_asg/services/product_service.dart';
import 'package:code_asg/views/search/search.dart';
import 'package:code_asg/views/widgets/product_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> productList = [];
  int currentPage = 0;

  Future _fetchData() async {
    final response = await ProductService().fetchProduct(currentPage);
    setState(() {
      productList.addAll(response);
      currentPage++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen()));
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: productList.length + 1, // +1 for Loading indicator
        itemBuilder: (context, index) {
          if (index < productList.length) {
            // Check for the last index to call _fetchData()
            final product = productList[index];
            return ProductTile(product: product);
          } else {
            _fetchData(); // Load more data when reaching the end
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
