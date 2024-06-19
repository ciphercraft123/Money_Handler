import 'package:money_handler/controller/balance_controller.dart';
import 'package:money_handler/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../firebase/FirebaseUtils.dart';
import '../utils/ColorsUtil.dart';
import '../utils/Utils.dart';
import '../widgets/Textformfield.dart';
import '../widgets/button.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final titleController = TextEditingController();
  final typeController = TextEditingController();
  final amountController = TextEditingController();
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final formatter = DateFormat.yMd();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final controller = Get.put(BalanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: ColorsUtil.lightBg,
        title: const Text("Add Expense"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              Text(
                "Title:-",
                style: TextStyle(color: ColorsUtil.lightBg),
              ),
              const SizedBox(
                height: 5,
              ),
              TextformField(
                textController: titleController,
                hinttext: 'Enter title',
                keyboardType: TextInputType.text,
                isPadding: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Your Title";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Expense Type:-",
                style: TextStyle(color: ColorsUtil.lightBg),
              ),
              const SizedBox(
                height: 5,
              ),
              TextformField(
                textController: typeController,
                hinttext: 'Enter Type',
                keyboardType: TextInputType.text,
                isPadding: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Your Expense Type";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Amount:-",
                style: TextStyle(color: ColorsUtil.lightBg),
              ),
              const SizedBox(
                height: 5,
              ),
              TextformField(
                textController: amountController,
                hinttext: 'Enter Amount',
                isPadding: false,
                keyboardType: TextInputType.number,
                inputFormatter: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Amount";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              IconButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final firstDate = DateTime(now.year - 1, now.month, now.day);
                  var pickedDate = await showDatePicker(
                    context: context,
                    firstDate: firstDate,
                    lastDate: now,
                    initialDate: now,
                  );
                  if (pickedDate != null) selectedDate.value = pickedDate;
                  // print(selectedDate.value);
                },
                icon: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Obx(
                      () => Text(
                        selectedDate.value == null
                            ? 'Pick Date'
                            : formatter
                                .format(selectedDate.value ?? DateTime.now()),
                        style: TextStyle(color: ColorsUtil.lightBg),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Button(
                  text: 'Save',
                  onTap: () {
                    if (_formkey.currentState!.validate()) {
                      FirebaseUtils.addExpenses(
                        Expense(
                          title: titleController.text,
                          type: typeController.text,
                          amount: double.tryParse(amountController.text),
                          date: formatter.format(
                            selectedDate.value ?? DateTime.now(),
                          ),
                        ),
                      );

                      controller.getExpense();

                      Utils.showSnackbar(
                        "Expense Added Successfully",
                        const Duration(seconds: 2),
                        Colors.green,
                      );
                      titleController.clear();
                      typeController.clear();
                      amountController.clear();
                      selectedDate.value = null;
                    }
                  },
                  bRadius: 10,
             buttonStyle: Buttonstyle.secondary,
                  height: 40,
                  width: 120,
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
