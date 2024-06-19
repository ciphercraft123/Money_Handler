import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_handler/controller/balance_controller.dart';
import 'package:money_handler/firebase/FirebaseUtils.dart';
import 'package:money_handler/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/ColorsUtil.dart';

class IncomesExpenses extends StatelessWidget {
  final bool isIncome;
  final bool isAppbar;
  final bool? isPadding;

  const IncomesExpenses({
    super.key,
    required this.isIncome,
    this.isAppbar = false,
    this.isPadding,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BalanceController());

    QueryDocumentSnapshot<Map<String, dynamic>>? lastDeletedItem;

    return Scaffold(
      backgroundColor: ColorsUtil.darkBg,
      appBar: isAppbar
          ? AppBar(
              backgroundColor: ColorsUtil.darkBg,
              foregroundColor: Colors.white,
              title: Text(isIncome ? "Incomes" : "Expenses"),
              centerTitle: true,
            )
          : null,
      body: Obx(() {
        var dataList = controller.incomeList.value;
        if (!isIncome) {
          dataList = controller.expenseList.value;
        }
        if (dataList == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataList.isEmpty) {
          return Center(
            child: Text(
              isIncome ? "Add Incomes" : "Add Expenses",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            var inc = dataList![index];
            if (dataList.isEmpty) {
              return Center(
                child: Text(
                  isIncome ? "Add Incomes" : "Add Expenses",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }
            return Padding(
              padding: isPadding == true
                  ? const EdgeInsets.symmetric(horizontal: 20)
                  : EdgeInsets.zero,
              child: Dismissible(
                key: ValueKey(inc),
                onDismissed: (direction) async {
                  lastDeletedItem = inc;
                  if (isIncome) {
                    controller.incomeList.value?.remove(inc);
                    controller.incomeList.refresh();
                    controller.getTotalIncome();
                  } else {
                    controller.expenseList.value?.remove(inc);
                    controller.expenseList.refresh();
                    controller.getTotalExpense();
                  }

                  Utils.showSnackbar(
                      '${isIncome ? "Income" : "Expense"} deleted successfully',
                      const Duration(seconds: 3),
                      Colors.green,
                      action: SnackBarAction(
                        label: "Undo",
                        onPressed: () {
                          lastDeletedItem = null;
                          if (isIncome) {
                            controller.incomeList.value?.add(inc);
                            controller.incomeList.refresh();
                            controller.getTotalIncome();
                          } else {
                            controller.expenseList.value?.add(inc);
                            controller.expenseList.refresh();
                            controller.getTotalExpense();
                          }
                        },
                      ));
                  Future.delayed(
                    const Duration(seconds: 3),
                    () async {
                      if (lastDeletedItem == null) return;
                      await FirebaseUtils.deleteIncomeExpense(
                          inc.id, isIncome ? "Incomes" : "Expenses");
                      if (isIncome) {
                        controller.getIncome();
                        return;
                      }
                      controller.getExpense();
                    },
                  );
                },
                child: Card(
                  color: isIncome
                      ? const Color(0xffa0ffa3)
                      : const Color(0xffff9ca9),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        child: Row(
                          children: [
                            Text(
                              inc["title"],
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              inc["amount"].toString(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 10, left: 10, bottom: 3),
                        child: Row(
                          children: [
                            Text(
                              inc["type"],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              inc["date"],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
