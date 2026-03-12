import 'package:flutter/material.dart';

class Constants {

  static final List<Map<String, String>> onboardingData = [
    {
      'title': 'Track your income & expenses',
      'description': 'Easily manage your daily transactions with AI categorization.',
    },
    {
      'title': 'Get AI insights & suggestions',
      'description': 'Our AI agent analyzes your spending and gives personalized advice.',
    },
    {
      'title': 'Stay on top of your money automatically',
      'description': 'Automate your savings and reach your financial goals faster.',
    },
  ];


  static final List<Map<String, dynamic>> transactionCategories = [
    {'name': 'Groceries', 'icon': Icons.local_grocery_store_rounded, 'emoji': '🛒'},
    {'name': 'Bills', 'icon': Icons.receipt_long_rounded, 'emoji': '🧾'},
    {'name': 'Health', 'icon': Icons.local_hospital_rounded, 'emoji': '🏥'},
    {'name': 'Education', 'icon': Icons.school_rounded, 'emoji': '🎓'},
    {'name': 'Travel', 'icon': Icons.flight_takeoff_rounded, 'emoji': '✈️'},
    {'name': 'Savings', 'icon': Icons.savings_rounded, 'emoji': '🏦'},
    {'name': 'Investment', 'icon': Icons.trending_up_rounded, 'emoji': '📈'},
    {'name': 'Gifts', 'icon': Icons.card_giftcard_rounded, 'emoji': '🎁'},
    {'name': 'Subscriptions', 'icon': Icons.subscriptions_rounded, 'emoji': '📺'},
    {'name': 'Pets', 'icon': Icons.pets_rounded, 'emoji': '🐶'},
    {'name': 'Charity', 'icon': Icons.volunteer_activism_rounded, 'emoji': '🤝'},
    {'name': 'Other', 'icon': Icons.category_rounded, 'emoji': '📦'},
  ];

}