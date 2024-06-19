import 'package:money_handler/utils/ColorsUtil.dart';
import 'package:money_handler/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/balance_controller.dart';
import 'incomes_expenses.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  final controller = Get.put(BalanceController());

  @override
  Widget build(BuildContext context) {
    controller.getExpense();
    controller.getIncome();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorsUtil.darkBg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Obx(() {
                      return ContainerWidget(
                        height: 100,
                        width: 150,
                        borderRadius: 10,
                        colors: const [Colors.green, Colors.yellow],
                        text: "Income",
                        iconcolor: Colors.green,
                        icon: Icons.import_export_rounded,
                        amount: controller.totalIncome.value,
                      );
                    }),
                    Obx(() {
                      return ContainerWidget(
                        height: 100,
                        width: 150,
                        borderRadius: 10,
                        colors: const [Colors.red, Colors.yellow],
                        text: 'Expense',
                        iconcolor: Colors.red,
                        icon: Icons.import_export_rounded,
                        amount: controller.totalExpense.value,
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(() {
                  var v = controller.totalIncome.value -
                      controller.totalExpense.value;
                  return ContainerWidget(
                    height: 100,
                    width: 150,
                    borderRadius: 10,
                    colors: const [Colors.lightBlue, Colors.yellow],
                    text: 'Balance',
                    iconcolor: Colors.white,
                    icon: Icons.account_balance_wallet,
                    amount: v,
                  );
                }),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const TabBar(
                    dividerColor: Colors.transparent,
                    tabs: [
                      Text(
                        "Incomes",
                      ),
                      Text("Expenses"),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                 const Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      IncomesExpenses(isIncome: true),
                      IncomesExpenses(isIncome: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
