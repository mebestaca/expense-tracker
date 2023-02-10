import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../models/model_items.dart';
import '../../services/database.dart';
import '../text_decoration.dart';
import 'error_card.dart';
import 'loading_screen.dart';

enum ExpenseEntryMode{
  add,
  edit,
  delete
}

class TodayDataEntry extends StatefulWidget {
  const TodayDataEntry({Key? key, required this.entryMode, required this.model, required this.id, required this.path, required this.categoryList}) : super(key: key);

  final ExpenseEntryMode entryMode;
  final ItemModel model;
  final String id;
  final String path;
  final List<String> categoryList;

  @override
  State<TodayDataEntry> createState() => _TodayDataEntryState();
}

class _TodayDataEntryState extends State<TodayDataEntry> {

  String itemName = "";
  String amount = "";
  late String transDate;
  late String category;

  final itemNameController = TextEditingController();
  final amountController = TextEditingController();
  final transDateController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  late DateTime currentDate;
  final dateFormatter = DateFormat("yyyy-MM-dd");

  String errorText = "";
  bool isInhibited = false;

  @override
  void initState() {
    currentDate = DateTime.now();
    transDate = dateFormatter.format(currentDate);
    transDateController.text = transDate;
    category = widget.categoryList.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (widget.entryMode == ExpenseEntryMode.edit) {
      setState(() {
        if (!isInhibited) {
          transDate = widget.model.transDate;
          transDateController.text = transDate;
          itemName = widget.model.name;
          itemNameController.text = itemName;
          amount = widget.model.amount.toString();
          amountController.text = amount;
          category = widget.model.category;
          isInhibited = true;
        }
      });
    }

    return SingleChildScrollView(
      child: Stack(
        children: [
          Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: errorText.isNotEmpty ? true : false,
                  child: ErrorCard(errorText: errorText),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      readOnly: true,
                      controller: transDateController,
                      decoration: fieldStyle.copyWith(
                        hintText: "date",
                        labelText: "date",
                        suffixIcon: IconButton(
                            onPressed: () => _selectDate(context),
                            icon: const Icon(Icons.calendar_month)
                        )
                      ),
                      onChanged: (val) {
                        setState(() {
                          transDate = val;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: itemNameController,
                      validator: (val) {
                        if (itemName.length < 2) {
                          errorText = "please enter an item name";
                        }
                      },
                      decoration: fieldStyle.copyWith(
                          hintText: "item name",
                          labelText: "item name"
                      ),
                      onChanged: (val) {
                        setState(() {
                          errorText = "";
                          itemName = val;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                      inputFormatters:  [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                        try{
                          final text = newValue.text;
                          if (text.isNotEmpty) double.parse(text);
                          return newValue;
                        }catch (e) {
                          null;
                        }
                        return oldValue;
                      }),
                      ],
                      controller: amountController,
                      validator: (val) {
                        if (amount.isEmpty) {
                          errorText = errorText.isEmpty ? "please enter an amount" : "$errorText\nplease enter an amount";
                        }
                      },
                      decoration: fieldStyle.copyWith(
                          hintText: "amount",
                          labelText: "amount"
                      ),
                      onChanged: (val) {
                        setState(() {
                          errorText = "";
                          amount = val;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.black)
                        ),
                        child: DropdownButton(
                          underline: const SizedBox(),
                          isExpanded: true,
                          value: category,
                          items: widget.categoryList.map((categories) {
                            return DropdownMenuItem(
                                value: categories,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(categories),
                                )
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              category = val!;
                            });
                          }
                        ),
                      ),
                    ),
                  )
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()){
                              setState(() {

                              });
                              FocusScope.of(context).unfocus();

                              Map<String, dynamic> data = {
                                ItemModel.fieldName : itemName,
                                ItemModel.fieldAmount : amount,
                                ItemModel.fieldDate : transDate,
                                ItemModel.fieldCategory : category
                              };

                              final snackBar = SnackBar(
                                content: Text("$itemName added"),
                                action: SnackBarAction(
                                  label: "Ok",
                                  onPressed: () {

                                  },
                                ),
                              );

                              if (widget.entryMode == ExpenseEntryMode.add) {
                                await DatabaseService(path: widget.path).addEntry(data);

                                setState(() {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                  itemName = "";
                                  itemNameController.clear();
                                  amount = "";
                                  amountController.clear();
                                  currentDate = DateTime.now();
                                  transDate = dateFormatter.format(currentDate);
                                  transDateController.text = transDate;
                                  category = widget.categoryList.first;

                                });
                              }

                              if (widget.entryMode == ExpenseEntryMode.edit) {
                                await DatabaseService(path: widget.path).updateEntry(data, widget.id).then((value) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Navigator.pop(context);
                                });
                              }

                            }
                          },
                          child: const Text("Confirm")
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: isLoading,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.width / 2,),
              child: const Loading(),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2020, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != currentDate) {
      setState(() {
        currentDate = picked;
        transDate = dateFormatter.format(currentDate);
        transDateController.text = transDate;
      });
    }
  }
}
