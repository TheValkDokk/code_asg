import 'package:code_asg/constain.dart';
import 'package:code_asg/models/debouncer.dart';
import 'package:code_asg/models/product.dart';
import 'package:code_asg/services/product_service.dart';
import 'package:code_asg/views/search/widgets/search_bar.dart';
import 'package:code_asg/views/widgets/product_tile.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: debouncer);
  List<Product> productList = [];
  bool isLoading = false;

  Future _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await ProductService().fetchProductWithSearch(_searchController.text);
    setState(() {
      productList = response;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();

    _searchController.addListener(() {
      _debouncer.run(() {
        if (_searchController.text.isNotEmpty) {
          _fetchData();
        } else {
          setState(() {
            productList.clear();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchTextField(
          searchController: _searchController,
          searchFocusNode: _searchFocusNode,
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : productList.isNotEmpty
              ? ListView.builder(
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    final product = productList[index];
                    return ProductTile(product: product);
                  },
                )
              : const Center(
                  child: Text("Search something"),
                ),
    );
  }
}
