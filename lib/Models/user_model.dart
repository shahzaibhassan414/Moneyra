import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneyra/Models/category_model.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final double monthlyIncome;
  final double monthlyExpense;
  final String currency;
  final String currencySymbol;
  final List<CategoryModel> additionalCategories;
  final bool isSetupComplete;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.currency,
    required this.currencySymbol,
    required this.additionalCategories,
    required this.isSetupComplete,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      monthlyIncome: (map['monthlyIncome'] ?? 0).toDouble(),
      monthlyExpense: (map['monthlyExpense'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'USD',
      currencySymbol: map['currencySymbol'] ?? '\$',
      additionalCategories: (map['additionalCategories'] as List<dynamic>?)
              ?.map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      isSetupComplete: map['isSetupComplete'] ?? false,
    );
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }
}
