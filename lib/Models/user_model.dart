import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final double monthlyIncome;
  final String currency;
  final List<String> additionalCategories;
  final bool isSetupComplete;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.monthlyIncome,
    required this.currency,
    required this.additionalCategories,
    required this.isSetupComplete,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      monthlyIncome: (map['monthlyIncome'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'USD',
      additionalCategories: List<String>.from(map['additionalCategories'] ?? []),
      isSetupComplete: map['isSetupComplete'] ?? false,
    );
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }
}
