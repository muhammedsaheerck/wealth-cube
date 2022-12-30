import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management/infrastructure/category/category_db.dart';
import 'package:money_management/infrastructure/transactions/transaction_db.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/models/transaction/transaction_model.dart';
import 'package:money_management/presentation/category/widgets/add_category_popup.dart';
import 'package:money_management/presentation/home/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';

import '../../application/add_transaction/screen_add_note_provider.dart';

//Screen add Transaction
class ScreenAddNote extends StatelessWidget {
  ScreenAddNote({super.key});

  DateTime? _selectedDateTemp;
  final _formKey = GlobalKey<FormState>();
  final _amountTextEditingController = TextEditingController();
  final _purposeTextEditingController = TextEditingController();

  CategoryModel? _selectedCategoryModel;

  @override
  Widget build(BuildContext context) {
    print('11');
    return SafeArea(
      child: Column(children: [
//Radio button Incom and Expense
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Consumer<ScreenAddNoteProvider>(
                builder: (context, value, child) => Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: CategoryType.income,
                  groupValue: value.selectedCatrgoryType,
                  onChanged: (values) {
                    value.categoryType(values);
                    value.categoryId = null;
                  },
                ),
              ),
              const Text(
                'Income',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(
                width: 100,
              ),
              Consumer<ScreenAddNoteProvider>(
                builder: (context, value, child) => Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: CategoryType.expense,
                  groupValue: value.selectedCatrgoryType,
                  onChanged: (values) {
                    value.categoryType(values);
                    value.categoryId = null;
                  },
                ),
              ),
              const Text(
                'Expense',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
//Dropdown button - category choose
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButtonHideUnderline(
              child: Consumer<ScreenAddNoteProvider>(
                builder: (context, value, child) => DropdownButton2(
                  hint: Row(
                    children: [
                      Text(
                        'Select Category',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  value: value.categoryId,
                  items: (value.selectedCatrgoryType == CategoryType.income
                          ? CategoryDb().incomCategoryListListener
                          : CategoryDb().expenseCategoryListListener)
                      .value
                      .map((e) {
                    return DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name),
                      onTap: () {
                        _selectedCategoryModel = e;
                      },
                    );
                  }).toList(),
                  onChanged: (selectedValue) {
                    value.selecteCategory(selectedValue);
                  },
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).primaryColor,
                  ),
                  buttonPadding: const EdgeInsets.only(left: 10),
                  buttonWidth: 170,
                  style: Theme.of(context).textTheme.headline6,
                  buttonElevation: 3,
                  itemHeight: 35,
                  dropdownMaxHeight: 150,
                  dropdownWidth: 170,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Theme.of(context).primaryColor,
                  ),
                  dropdownElevation: 1,
                  scrollbarRadius: const Radius.circular(40),
                  scrollbarAlwaysShow: true,
                  scrollbarThickness: 5,
                ),
              ),
            ),
//Icon Button- Category Add
            Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Consumer<ScreenAddNoteProvider>(
                  builder: (context, value, child) => IconButton(
                      onPressed: () {
                        // setState(() {
                        showCategoryAdd(context, value);
                        // });
                      },
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).iconTheme.color,
                      )),
                ))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
//TextFormField -Pick Calender -Choose Date
        Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                  child: Consumer<ScreenAddNoteProvider>(
                    builder: (context, value, child) => TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      readOnly: true,
                      controller: value.selectedDateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select the date';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('Select Date'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      onTap: (() async {
                        _selectedDateTemp = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 30)),
                            lastDate: DateTime.now());
                        if (_selectedDateTemp != null) {
                          value.datePicker(_selectedDateTemp!);
                        }
                      }),
                    ),
                  ),
                ),
//TextFormField- Add Amount
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    controller: _amountTextEditingController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill the Amount';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: const Text('Amount'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
//TextFormField- Add  Purpose
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _purposeTextEditingController,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please fill the Purpose';
                    //   }
                    // },
                    maxLength: 30,
                    decoration: InputDecoration(
                      label: const Text('Purpose'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
              ],
            )),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 100,
          child: Consumer<ScreenAddNoteProvider>(
            builder: (context, value, child) => ElevatedButton(
              onPressed: () {
                addTransaction(context, value);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 1,
              ),
              child: Text(
                'Submit',
                style: GoogleFonts.nunito(
                    textStyle: Theme.of(context).textTheme.headline6),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future addTransaction(
      BuildContext context, ScreenAddNoteProvider value) async {
    if (_amountTextEditingController.text.isEmpty &&
        // _purposeTextEditingController.text.isEmpty &&
        value.selectedDateController.text.isEmpty &&
        _selectedCategoryModel == null &&
        value.categoryId == null) {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 1,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          backgroundColor: Theme.of(context).primaryColor,
          duration: const Duration(milliseconds: 500),
          content: const Text(
            'Please fill the form',
            style: TextStyle(fontWeight: FontWeight.bold),
          )));
    } else if (_formKey.currentState!.validate() && value.categoryId != null) {
      final parsedAmount = double.tryParse(_amountTextEditingController.text);
      print(_selectedDateTemp);
      final model = TransactionModel(
          purpos: _purposeTextEditingController.text,
          amount: parsedAmount!,
          category: _selectedCategoryModel!,
          date: _selectedDateTemp!,
          type: value.selectedCatrgoryType!);

      await TransactionDb.instence.insertTransaction(model);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 1,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          backgroundColor: Theme.of(context).primaryColor,
          duration: const Duration(milliseconds: 800),
          content: const Text(
            'Details Added Successfully',
            style: TextStyle(fontWeight: FontWeight.bold),
          )));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => BottomNavigation())));

      TransactionDb.instence.refresh();
    }
  }

//Category Add Function
  final _nameCategoryController = TextEditingController();
  Future<void> showCategoryAdd(
      BuildContext context, ScreenAddNoteProvider value) async {
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
                children: [
                  RadioButtonCategory(
                      title: 'Income', type: CategoryType.income),
                  RadioButtonCategory(
                      title: 'Expense', type: CategoryType.expense),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                  onPressed: () {
                    value.addCategory(
                        name: _nameCategoryController.text,
                        type: selectedCategoryNotifier.value);
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
}
