import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:money_management/db_functions/category/category_db.dart';
import 'package:money_management/db_functions/transactions/transaction_db.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/models/transaction/transaction_model.dart';
import 'package:money_management/screens/Category/add_category_popup.dart';
import 'package:money_management/screens/Home/bottom_navigation.dart';

//Screen Update Transaction
class ScreenUpdateTransaction extends StatefulWidget {
  final int index;
  final TransactionModel transactionModelobj;
  const ScreenUpdateTransaction(
      {super.key, required this.index, required this.transactionModelobj});

  @override
  State<ScreenUpdateTransaction> createState() =>
      _ScreenUpdateTransactionState();
}

class _ScreenUpdateTransactionState extends State<ScreenUpdateTransaction> {
  DateTime? _selectedDateTemp;
  final _formKey = GlobalKey<FormState>();
  final _amountTextEditingController = TextEditingController();
  final _purposeTextEditingController = TextEditingController();
  final _selectedDateController = TextEditingController();
  CategoryType? _selectedCatrgoryType;
  CategoryModel? _selectedCategoryModel;
  String? _categoryId;

  @override
  void initState() {
    _selectedCatrgoryType = widget.transactionModelobj.type;
    _purposeTextEditingController.text = widget.transactionModelobj.purpos;
    _amountTextEditingController.text =
        widget.transactionModelobj.amount.toString();
    _selectedDateTemp = widget.transactionModelobj.date;
    _selectedDateController.text =
        DateFormat('dd-MM-yyyy').format(_selectedDateTemp!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
//Radio button Income and Exoense
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: CategoryType.income,
                  groupValue: _selectedCatrgoryType,
                  onChanged: (value) {
                    setState(() {
                      _selectedCatrgoryType = value;
                    });
                    _categoryId = null;
                  },
                ),
                const Text(
                  'Income',
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(
                  width: 100,
                ),
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: CategoryType.expense,
                  groupValue: _selectedCatrgoryType,
                  onChanged: (value) {
                    setState(() {
                      _selectedCatrgoryType = value;
                    });
                    _categoryId = null;
                  },
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
//Dropdown Button - Choose Category
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  hint: Row(
                    children: [
                      Text(
                        'Select Category',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  value: _categoryId,
                  items: (_selectedCatrgoryType == CategoryType.income
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
                    setState(() {
                      _categoryId = selectedValue;
                    });
                  },
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).primaryColor,
                  ),
                  buttonPadding: const EdgeInsets.only(left: 10),
                  style: Theme.of(context).textTheme.headline6,
                  buttonWidth: 170,
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
              const SizedBox(
                width: 40,
              ),
//Icon Button- Add Category
              Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: IconButton(
                      onPressed: () {
                        showCategoryAdd(context);
                      },
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).iconTheme.color,
                      )))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
//TextFormField- Pick Calender-Choose Date
          Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, right: 20),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      readOnly: true,
                      controller: _selectedDateController,
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
                          setState(() {
                            _selectedDateController.text =
                                DateFormat('dd-MM-yyyy')
                                    .format(_selectedDateTemp!);
                          });
                        }
                      }),
                    ),
                  ),
//TextFormField- Add Amount
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
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
//TextFormField- Add Purpose
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
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
            child: ElevatedButton(
              onPressed: () {
                updateTransaction(widget.index);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 1,
              ),
              child: Text(
                'Update',
                style: GoogleFonts.nunito(
                    textStyle: Theme.of(context).textTheme.headline6),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future updateTransaction(index) async {
    if (_amountTextEditingController.text.isEmpty &&
        // _purposeTextEditingController.text.isEmpty &&
        _selectedDateController.text.isEmpty &&
        _selectedCategoryModel == null &&
        _categoryId == null) {
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
    } else if (_formKey.currentState!.validate() && _categoryId != null) {
      final parsedAmount = double.tryParse(_amountTextEditingController.text);
      final model = TransactionModel(
          purpos: _purposeTextEditingController.text,
          amount: parsedAmount!,
          category: _selectedCategoryModel!,
          date: _selectedDateTemp!,
          type: _selectedCatrgoryType!);

      await TransactionDb.instence.updateTransaction(index, model);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 1,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          backgroundColor: Theme.of(context).primaryColor,
          duration: const Duration(milliseconds: 800),
          content: const Text(
            'Details Updated Successfully',
            style: TextStyle(fontWeight: FontWeight.bold),
          )));

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => const BottomNavigation())));
      TransactionDb.instence.refresh();
    }
  }

  //Category Add Function
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
                    setState(() {
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
                      CategoryDb.instance.refreshUI();
                      Navigator.of(ctx).pop();
                    });
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
