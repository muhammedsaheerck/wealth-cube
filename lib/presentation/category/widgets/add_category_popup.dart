import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management/infrastructure/category/category_db.dart';
import '../../../models/category/category_model.dart';

//Add Category - pop Up
ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);
final _nameCategoryController = TextEditingController();

 Future<void> showCategoryAdd(BuildContext context) async {
//pop up-
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text(
            'Add Category',
            style: GoogleFonts.nunito(
                textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            textAlign: TextAlign.center,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _nameCategoryController,
                decoration: const InputDecoration(
                  hintText: 'Category name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
//Radio-Income and Expense
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
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      type: type);
                  CategoryDb().insertCategory(category);
                  Navigator.of(ctx).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Add',
                  style: GoogleFonts.nunito(
                      textStyle: Theme.of(context).textTheme.headline6),
                ),
              ),
            ),
          ],
        );
      });
}

//rdio button

class RadioButtonCategory extends StatelessWidget with  ChangeNotifier {
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
