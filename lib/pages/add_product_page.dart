import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecom_admin/models/category_model.dart';
import 'package:ecom_admin/models/date_model.dart';
import 'package:ecom_admin/models/product_models.dart';
import 'package:ecom_admin/models/purchase_model.dart';
import 'package:ecom_admin/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../utils/helper_functions.dart';

class AddProductPage extends StatefulWidget {
  static const String routeName = '/add_product';

  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  late ProductProvider _productProvider;
  final _nameController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _longDescriptionController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _productDiscountController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _purchaseQuantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  CategoryModel? categoryModel;
  DateTime? purchaseDate;
  String? thumbnail;
  bool _isConnected = true;
  ImageSource _imageSource = ImageSource.gallery;
  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    isConnectedToInternet().then((value) {
      setState(() {
        _isConnected = value;
      });
    });
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        setState(() {
          _isConnected = true;
        });
      } else {
        setState(() {
          _isConnected = false;
        });
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Product'),
        actions: [
          IconButton(
              onPressed: _isConnected ? _saveProduct : null,
              icon: const Icon(Icons.save))
        ],
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (!_isConnected)
                  const ListTile(
                    tileColor: Colors.black,
                    title: Text(
                      'No internet connection',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<ProductProvider>(
                    builder: (context, provider, child) =>
                        DropdownButtonFormField<CategoryModel>(
                            isExpanded: true,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.category),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 1))),
                            hint: const Text('Select Category'),
                            items: provider.categoryList
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
                            }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'Product Name',
                        labelText: 'Product Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 1))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field must not be empty';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 2,
                    controller: _shortDescriptionController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.description),
                        labelText: 'Enter Short Description(optional)',
                        hintText: 'Enter Short Description(optional)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 1))),
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 3,
                    controller: _longDescriptionController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.description),
                        hintText: 'Enter Long Description(optional)',
                        labelText: 'Enter Long Description(optional)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 1))),
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _purchasePriceController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.attach_money),
                        hintText: 'Enter Purchase Price',
                        labelText: 'Enter Purchase Price',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 1))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field must not be empty';
                      }
                      if (num.parse(value) <= 0) {
                        return 'Purchase Price should be greater than 0';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _salePriceController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.attach_money),
                        hintText: 'Enter Sale Price',
                        labelText: 'Enter Sale Price',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 1))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field must not be empty';
                      }
                      if (num.parse(value) <= 0) {
                        return 'Sale Price should be greater than 0';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _purchaseQuantityController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.attach_money),
                        hintText: 'Enter Quantity',
                        labelText: 'Enter Quantity',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 1))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field must not be empty';
                      }
                      if (num.parse(value) <= 0) {
                        return 'Quantity should be greater than 0';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _productDiscountController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.discount),
                        hintText: 'Enter Discount',
                        labelText: 'Enter Discount',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 1))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field must not be empty';
                      }
                      if (num.parse(value) < 0) {
                        return 'Discount should be greater than 0';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: _selectDate,
                            icon: const Icon(Icons.calendar_month),
                            label: const Text('Select Purchase Date'),
                          ),
                          Text(purchaseDate == null
                              ? 'No date chosen'
                              : getFormattedDate(
                                  purchaseDate!,
                                ))
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            child: thumbnail == null
                                ? const Icon(
                                    Icons.photo,
                                    size: 100,
                                  )
                                : Image.file(
                                    File(thumbnail!),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  _imageSource = ImageSource.camera;
                                  _getImage();
                                },
                                icon: const Icon(Icons.camera),
                                label: const Text('Open Camera'),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  _imageSource = ImageSource.gallery;
                                  _getImage();
                                },
                                icon: const Icon(Icons.photo_album),
                                label: const Text('Open Gallery'),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shortDescriptionController.dispose();
    _longDescriptionController.dispose();
    _salePriceController.dispose();
    _productDiscountController.dispose();
    _purchasePriceController.dispose();
    _purchaseQuantityController.dispose();
    subscription.cancel();
    super.dispose();
  }

  void _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        purchaseDate = selectedDate;
      });
    }
  }

  void _getImage() async {
    final file =
        await ImagePicker().pickImage(source: _imageSource, imageQuality: 70);
    if (file != null) {
      setState(() {
        thumbnail = file.path;
      });
    }
  }

  void _saveProduct() async {
    if (thumbnail == null) {
      showMsg(context, 'Please Select an Image');
      return;
    }
    if (purchaseDate == null) {
      showMsg(context, 'Please Select a purchase date');
      return;
    }
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait');
      try {
        final imageModel = await _productProvider.uploadImage(thumbnail!);
        final productModel = ProductModel(
          productName: _nameController.text,
          shortDescription: _shortDescriptionController.text.isEmpty
              ? null
              : _shortDescriptionController.text,
          longDescription: _longDescriptionController.text.isEmpty
              ? null
              : _longDescriptionController.text,
          salePrice: num.parse(_salePriceController.text),
          productDiscount: num.parse(_productDiscountController.text),
          stock: num.parse(_purchaseQuantityController.text),
          category: categoryModel!,
          additionalImageModels: ['','',''],
          thumbnailImageModel: imageModel,
        );

        final purchaseModel = PurchaseModel(
          purchaseQuantity: num.parse(_purchaseQuantityController.text),
          purchasePrice: num.parse(_purchasePriceController.text),
          dateModel: DateModel(
            timestamp: Timestamp.fromDate(purchaseDate!),
            day: purchaseDate!.day,
            month: purchaseDate!.month,
            year: purchaseDate!.year,
          ),
        );
        await _productProvider.addNewProduct(productModel,purchaseModel);
        EasyLoading.dismiss();
        if(mounted)showMsg(context, 'Saved');
        resetFields();
      } catch (error) {
        EasyLoading.dismiss();
        showMsg(context, 'Could not save, Please check your connection');
        throw error;
      }
    }
  }

  void resetFields() {
    setState(() {
      _nameController.clear();
      _shortDescriptionController.clear();
      _longDescriptionController.clear();
      _productDiscountController.clear();
      _purchaseQuantityController.clear();
      _salePriceController.clear();
      _purchasePriceController.clear();
      categoryModel = null;
      purchaseDate = null;
      thumbnail = null;

    });
  }
}
