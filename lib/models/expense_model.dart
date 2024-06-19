import 'dart:convert';

Expense expenseFromJson(String str) => Expense.fromJson(json.decode(str));

String expenseToJson(Expense data) => json.encode(data.toJson());

class Expense {
  String? title;
  String? type;
  double? amount;
  String? date;

  Expense({
    this.title,
    this.type,
    this.amount,
    this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    title: json["title"],
    type: json["source"],
    amount: json["amount"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "source": type,
    "amount": amount,
    "date": date,
  };
}
