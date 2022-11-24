import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../db_functions/category/category_db.dart';
import '../../models/category/category_model.dart';

//Edit Category Pop Up

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);
final _nameCategoryController = TextEditingController();

Future<void>  showCategoryUpdate(
    BuildContext context, CategoryModel categoryModel) async {
  _nameCategoryController.text = categoryModel.name;
  selectedCategoryNotifier.value = categoryModel.type;
//popup-category add
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          title: Text(
            'Update Category',
            style: GoogleFonts.nunito(
                textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            textAlign: TextAlign.center,
          ),
          children: [
//TextField- Category Add
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _nameCategoryController,
                decoration: const InputDecoration(
                  hintText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
//Radio Button -choose Income and Expense
            Row(
              children:  [
                RadioButtonCategory(title: 'Income', type: CategoryType.income),
                RadioButtonCategory(
                    title: 'Expense', type: CategoryType.expense),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                onPressed: () {
                  final name = _nameCategoryController.text;
                  if (name.isEmpty) {
                    return;
                  }
                  final type = selectedCategoryNotifier.value;
                  final category = CategoryModel(
                      id: categoryModel.id, name: name, type: type);
                  CategoryDb().insertCategory(category);
                  Navigator.of(ctx).pop();
                },
                style: ElevatedButton.styleFrom(
                  // backgroundColor: Colors.indigo
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Update',
                  style: GoogleFonts.nunito(
                      textStyle: Theme.of(context).textTheme.headline6),
                ),
              ),
            ),
          ],
        );
      });
}

//Radio Button class

class RadioButtonCategory extends StatelessWidget with ChangeNotifier {
  final String title;
  final CategoryType type;
   RadioButtonCategory(
      {super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategoryNotifier,
            builder: (BuildContext ctx, CategoryType newCategory, _) {
              return Radio<CategoryType>(
                  activeColor: Theme.of(context).primaryColor,
                  value: type,
                  groupValue: newCategory,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    selectedCategoryNotifier.value = value;
                    selectedCategoryNotifier.notifyListeners();
                  });
            }),
        Text(title),
      ],
    );
  }
}
