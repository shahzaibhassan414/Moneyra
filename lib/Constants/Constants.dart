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
    {'name': 'Food', 'icon': Icons.restaurant_rounded, 'emoji': '🍔'},
    {'name': 'Rent', 'icon': Icons.home_rounded, 'emoji': '🏠'},
    {
      'name': 'Entertainment',
      'icon': Icons.sports_esports_rounded,
      'emoji': '🎮',
    },
    {'name': 'Transport', 'icon': Icons.directions_car_rounded, 'emoji': '🚗'},
    {'name': 'Shopping', 'icon': Icons.shopping_bag_rounded, 'emoji': '🛍️'},
    {'name': 'Salary', 'icon': Icons.payments_rounded, 'emoji': '💰'},
  ];

}