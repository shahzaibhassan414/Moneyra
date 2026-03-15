import 'package:flutter/material.dart';
import '../Models/category_model.dart';

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

  static final List<CategoryModel> transactionCategories = [
    CategoryModel(name: 'Groceries', emoji: '🛒'),
    CategoryModel(name: 'Bills', emoji: '🧾'),
    CategoryModel(name: 'Health', emoji: '🏥'),
    CategoryModel(name: 'Education', emoji: '🎓'),
    CategoryModel(name: 'Travel', emoji: '✈️'),
    CategoryModel(name: 'Savings', emoji: '🏦'),
    CategoryModel(name: 'Investments', emoji: '📈'),
    CategoryModel(name: 'Gifts', emoji: '🎁'),
    CategoryModel(name: 'Subscriptions', emoji: '📺'),
    CategoryModel(name: 'Pets', emoji: '🐶'),
    CategoryModel(name: 'Charity', emoji: '🤝'),
    CategoryModel(name: 'Other', emoji: '📦'),
  ];

  static final List<CategoryModel> incomeCategories = [
    CategoryModel(name: 'Salary', emoji: '💰'),
    CategoryModel(name: 'Business', emoji: '🏢'),
    CategoryModel(name: 'Freelance', emoji: '💻'),
    CategoryModel(name: 'Gift', emoji: '🎁'),
    CategoryModel(name: 'Investment Return', emoji: '📈'),
    CategoryModel(name: 'Other', emoji: '➕'),
  ];

  static final List<String> availableCategoryIcons = [
    "🍔", "🚗", "⛽", "🛍️", "👕", "🎮", "🎬", "☕", "💊", "📱", "💡", "🔧", "📺", "🤝", "🅿️", "🧮",
  ];
}
