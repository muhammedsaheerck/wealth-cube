import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management/db_functions/category/category_db.dart';
import 'package:money_management/screens/Category/update_category.dart';
import '../../models/category/category_model.dart';
//Screen Income Category
class IncomCategory extends StatelessWidget {
  const IncomCategory({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDb().incomCategoryListListener,
      builder: (BuildContext context, List<CategoryModel> newlist, Widget? _) {
//when Category not found - show This content
        return newlist.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add_to_photos,
                    size: 50,
                    color: Colors.black26,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('No Category Found!',
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 20,
                      )),
                ],
              )
//Category found-show Expense Category in Grid view
            : GridView.builder(
                itemCount: newlist.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: ((context, index) {
                  final category = newlist[index];
//Income Category Details
                  return Card(
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    shadowColor: Colors.grey,
                    elevation: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
//Category Delete
                              IconButton(
                                  onPressed: () {
//Category delete - confirmation pop up
                                    showDialog(
                                        context: context,
                                        builder: ((context) {
                                          return AlertDialog(
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            content: Text(
                                              'Do you Delete This Category?',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 18),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor: Theme
                                                                  .of(context)
                                                              .primaryColor),
                                                  onPressed: (() {
                                                    return Navigator.pop(
                                                        context);
                                                  }),
                                                  child: Text(
                                                    'Cancel',
                                                    style: GoogleFonts.nunito(
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .headline6),
                                                  )),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor: Theme
                                                                  .of(context)
                                                              .primaryColor),
                                                  onPressed: (() {
                                                    CategoryDb.instance
                                                        .deleteCategory(
                                                            category.id);

                                                    Navigator.of(context).pop();
                                                  }),
                                                  child: Text(
                                                    'Delete',
                                                    style: GoogleFonts.nunito(
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .headline6),
                                                  ))
                                            ],
                                          );
                                        })
                                        );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                              IconButton(
                                onPressed: () async {
                                  await showCategoryUpdate(context, category);
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue.shade800,
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          category.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  );
                }));
      },
    );
  }
}
