import 'package:kitchenowl/models/model.dart';

import 'expense_category.dart';
import 'nullable.dart';

class Expense extends Model {
  final int? id;
  final String name;
  final double amount;
  final String? image;
  final String? imageHash;
  final DateTime? date;
  final ExpenseCategory? category;
  final int paidById;
  final List<PaidForModel> paidFor;

  bool get isIncome => amount < 0;

  const Expense({
    this.id,
    this.name = '',
    this.amount = 0,
    this.image,
    this.imageHash,
    required this.paidById,
    this.paidFor = const [],
    this.date,
    this.category,
  });

  factory Expense.fromJson(Map<String, dynamic> map) {
    List<PaidForModel> paidFor = const [];
    if (map.containsKey('paid_for')) {
      paidFor = List.from(map['paid_for'].map((e) => PaidForModel.fromJson(e)));
    }

    return Expense(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      image: map['photo'],
      imageHash: map['photo_hash'],
      category: map['category'] != null
          ? ExpenseCategory.fromJson(map['category'])
          : null,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'], isUtc: true)
          .toLocal(),
      paidById: map['paid_by_id'],
      paidFor: paidFor,
    );
  }

  Expense copyWith({
    String? name,
    double? amount,
    DateTime? date,
    String? image,
    Nullable<ExpenseCategory>? category,
    int? paidById,
    List<PaidForModel>? paidFor,
  }) =>
      Expense(
        id: id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        image: image ?? this.image,
        imageHash: imageHash,
        category: (category ?? Nullable(this.category)).value,
        paidById: paidById ?? this.paidById,
        paidFor: paidFor ?? this.paidFor,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        amount,
        image,
        imageHash,
        category,
        date,
        paidById,
        paidFor,
      ];

  @override
  Map<String, dynamic> toJson() {
    assert(date != null);

    return {
      "name": name,
      "amount": amount,
      if (image != null) "photo": image,
      'category': category?.id,
      "date": date!.toUtc().millisecondsSinceEpoch,
      "paid_by": {"id": paidById},
      "paid_for": paidFor.map((e) => e.toJson()).toList(),
    };
  }

  @override
  Map<String, dynamic> toJsonWithId() => toJson()
    ..addAll({
      "id": id,
      if (imageHash != null) "photo_hash": imageHash,
    });
}

class PaidForModel extends Model {
  final int userId;
  final int factor;

  const PaidForModel({required this.userId, this.factor = 1});

  @override
  List<Object?> get props => [userId, factor];

  @override
  Map<String, dynamic> toJson() => {
        "id": userId,
        "factor": factor,
      };

  factory PaidForModel.fromJson(Map<String, dynamic> map) {
    return PaidForModel(
      userId: map['user_id'],
      factor: map['factor'],
    );
  }
}
