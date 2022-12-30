import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../infrastructure/category/category_db.dart';
import '../../models/category/category_model.dart';

class ScreenAddNoteProvider extends ChangeNotifier {
  ValueNotifier<CategoryType> selectedCategoryNotifier =
      ValueNotifier(CategoryType.income);
  final nameCategoryController = TextEditingController();
  CategoryType? selectedCatrgoryType = CategoryType.income;
  String? categoryId;
  DateTime? selectedDateTemp;
  final selectedDateController = TextEditingController();

  void categoryType(value) {
    selectedCatrgoryType = value;
    notifyListeners();
  }

  void categoryID(String value) {
    categoryId = value;
    notifyListeners();
  }

  void selecteCategory(String? selectedCategory) {
    categoryId = selectedCategory;
    notifyListeners();
  }

  void addCategory({required String name, required CategoryType type}) {
    // final type = selectedCategoryNotifier.value;
    final category = CategoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        type: type);
    CategoryDb().insertCategory(category);
    CategoryDb.instance.refreshUI();
    notifyListeners();
  }

  void datePicker(DateTime selectedDate) {
    selectedDateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
    notifyListeners();
  }
}
