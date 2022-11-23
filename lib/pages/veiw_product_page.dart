import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_admin/pages/product_details_page.dart';
import 'package:ecom_admin/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = '/view_product';

  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  CategoryModel? categoryModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<CategoryModel>(
                  isExpanded: true,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1))),
                  hint: const Text('Select Category'),
                  items: provider
                      .getCategoriesForFiltering()
                      .map((catModel) => DropdownMenuItem(
                            value: catModel,
                            child: Text(catModel.categoryName),
                          ))
                      .toList(),
                  value: categoryModel,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      categoryModel = value;
                    });
                    if (categoryModel!.categoryName == 'All') {
                      provider.getAllProducts();
                    } else {
                      provider.getAllProductsByCategory(
                          categoryModel!.categoryName);
                    }
                  }),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: provider.productList.length,
              itemBuilder: (context, index) {
                final product = provider.productList[index];
                return ListTile(
                  onTap: () => Navigator.pushNamed(
                      context, ProductDetailsPage.routeName,
                      arguments: product),
                  leading: CachedNetworkImage(
                    width: 50,
                    imageUrl: product.thumbnailImageModel.imageDownloadUrl,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  title: Text(product.productName),
                  subtitle: Text(product.category.categoryName),
                  trailing: Text('Stock ${product.stock}'),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
