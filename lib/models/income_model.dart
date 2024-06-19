import 'dart:convert';

Income incomeFromJson(String str) => Income.fromJson(json.decode(str));

String incomeToJson(Income data) => json.encode(data.toJson());

class Income {
  String? title;
  String? type;
  double? amount;
  String? date;

  Income({
    this.title,
    this.type,
    this.amount,
    this.date,
  });

  factory Income.fromJson(Map<String, dynamic> json) => Income(
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
