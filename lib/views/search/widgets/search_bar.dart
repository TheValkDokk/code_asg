import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required TextEditingController searchController,
    required FocusNode searchFocusNode,
  })  : _searchController = searchController,
        _searchFocusNode = searchFocusNode;

  final TextEditingController _searchController;
  final FocusNode _searchFocusNode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Center(
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
            hintText: 'Product Search',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
