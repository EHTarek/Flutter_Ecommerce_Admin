import 'package:ecom_admin/providers/product_provider.dart';
import 'package:ecom_admin/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  static const String routeName = '/category';

  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSingleTextFieldInputDialog(
            context: context,
            title: 'Category',
            positiveButton: 'ADD',
            onSubmit: (value) {
              Provider.of<ProductProvider>(context, listen: false)
                  .addCategory(value);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.categoryList.length,
          itemBuilder: (context, index) {
            final catModel = provider.categoryList[index];
            return ListTile(
              title: Text(catModel.categoryName),
              trailing: Text('Total : ${catModel.productCount}'),
            );
          },
        ),
      ),
    );
  }
}
