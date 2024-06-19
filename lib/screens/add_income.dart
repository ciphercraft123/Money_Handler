import 'package:money_handler/firebase/FirebaseUtils.dart';
import 'package:money_handler/utils/ColorsUtil.dart';
import 'package:money_handler/utils/Utils.dart';
import 'package:money_handler/widgets/Textformfield.dart';
import 'package:money_handler/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/balance_controller.dart';
import '../models/income_model.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
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
        title: const Text("Add Income"),
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
              const SizedBox(height: 5),
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
              const SizedBox(height: 15),
              Text(
                "Income Type:-",
                style: TextStyle(color: ColorsUtil.lightBg),
              ),
              const SizedBox(height: 5),
              TextformField(
                textController: typeController,
                hinttext: 'Enter Type',
                keyboardType: TextInputType.text,
                isPadding: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Your Income Type";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Text(
                "Amount:-",
                style: TextStyle(color: ColorsUtil.lightBg),
              ),
              const SizedBox(height: 5),
              TextformField(
                textController: amountController,
                hinttext: 'Enter Amount',
                keyboardType: TextInputType.number,
                inputFormatter: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                isPadding: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Amount";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
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
                },
                icon: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
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
              const SizedBox(height: 20),
              Center(
                child: Button(
                  text: 'Save',
                  onTap: () {
                    if (_formkey.currentState!.validate()) {
                      FirebaseUtils.addIncomes(
                        Income(
                          title: titleController.text,
                          type: typeController.text,
                          amount: double.tryParse(amountController.text),
                          date: formatter.format(
                            selectedDate.value ?? DateTime.now(),
                          ),
                        ),
                      );
                      controller.getIncome();
                      Utils.showSnackbar(
                        "Income Added Successfully",
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
