import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management/models/category/category_model.dart';
//Database Name
const categoryDbName = 'category_database';
//Category Functions (Abstract)
abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategory();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryId);
  Future<void> updateCategory(index, CategoryModel value);
}

//Inherit Abstract class
class CategoryDb with ChangeNotifier implements CategoryDbFunctions  {
//create Named constructor
  CategoryDb._internal();
  static CategoryDb instance = CategoryDb._internal();

  factory CategoryDb() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomCategoryListListener =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListListener =
      ValueNotifier([]);
//Add Category function
  @override
  Future<void> insertCategory(CategoryModel value) async {
    final categorydb = await Hive.openBox<CategoryModel>(categoryDbName);
    await categorydb.put(value.id, value);
    refreshUI();
  }

//Get Category funcion
  @override
  Future<List<CategoryModel>> getCategory() async {
    final categorydb = await Hive.openBox<CategoryModel>(categoryDbName);
    return categorydb.values.toList();
  }

//refresh funcion
  Future<void> refreshUI() async {
    final allCategories = await getCategory();
    incomCategoryListListener.value.clear();
    expenseCategoryListListener.value.clear();
    Future.forEach(allCategories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomCategoryListListener.value.add(category);
      } else {
        expenseCategoryListListener.value.add(category);
      }
    });
    incomCategoryListListener.notifyListeners();
    expenseCategoryListListener.notifyListeners();
  }

//Delete Category function
  @override
  Future<void> deleteCategory(String categoryId) async {
    final category = await Hive.openBox<CategoryModel>(categoryDbName);
    await category.delete(categoryId);
    refreshUI();
  }

//Reset All datas
  Future<void> resetAllCategory() async {
    final category = await Hive.openBox<CategoryModel>(categoryDbName);
    await category.clear();
  }

  //Update Category function
  @override
  Future<void> updateCategory( index, CategoryModel value) async {
    final category = await Hive.openBox<CategoryModel>(categoryDbName);
    category.putAt(index, value);
    refreshUI();
  }
}
