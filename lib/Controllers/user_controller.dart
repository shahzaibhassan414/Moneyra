import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../Models/user_model.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var user = Rxn<UserModel>();
  var isLoading = false.obs;

  var topExpenses = <Map<String, dynamic>>[].obs;
  var allTransactions = <Map<String, dynamic>>[].obs;
  
  // Monthly tracking
  var thisMonthIncome = 0.0.obs;
  var thisMonthExpense = 0.0.obs;

  // AI Insights
  var aiInsights = <String>[].obs;
  var isInsightsLoading = false.obs;

  // Gemini API Key
  final String _apiKey = "AIzaSyCSQSSiMsr7__pRsYSaJzNfSfTc_TS0XKs";

  StreamSubscription? _userSubscription;
  StreamSubscription? _transactionSubscription;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        _startListening(firebaseUser.uid);
      } else {
        _stopListening();
      }
    });
  }

  void _startListening(String uid) {
    print('UserController: Listening for data...');

    _userSubscription?.cancel();
    _userSubscription = _firestore.collection('users').doc(uid).snapshots().listen((doc) {
      if (doc.exists) {
        user.value = UserModel.fromDocument(doc);
      }
    });

    _transactionSubscription?.cancel();
    _transactionSubscription = _firestore
        .collection('transactions')
        .where('userId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .limit(50) // Fetch last 50 transactions for better context
        .snapshots()
        .listen((query) {
      allTransactions.value = query.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      _calculateMonthlyTotals();

      List<Map<String, dynamic>> expenses = allTransactions
          .where((tx) => tx['type'] == 'expense')
          .toList();
      
      expenses.sort((a, b) {
        double amountA = double.tryParse(a['amount'].toString()) ?? 0.0;
        double amountB = double.tryParse(b['amount'].toString()) ?? 0.0;
        return amountB.compareTo(amountA);
      });

      topExpenses.value = expenses.take(5).toList();

      // Generate insights if they are empty or transactions updated
      if (allTransactions.isNotEmpty && aiInsights.isEmpty && !isInsightsLoading.value) {
        generateAiInsights();
      }
    });
  }

  void _calculateMonthlyTotals() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    
    double incomeSum = 0.0;
    double expenseSum = 0.0;

    for (var tx in allTransactions) {
      final txDate = (tx['date'] as Timestamp).toDate();
      // Only sum transactions from the current month
      if (txDate.isAfter(startOfMonth) || txDate.isAtSameMomentAs(startOfMonth)) {
        double amount = double.tryParse(tx['amount'].toString()) ?? 0.0;
        if (tx['type'] == 'income') {
          incomeSum += amount;
        } else {
          expenseSum += amount;
        }
      }
    }

    thisMonthIncome.value = incomeSum;
    thisMonthExpense.value = expenseSum;
  }

  Future<void> generateAiInsights() async {
    if (allTransactions.isEmpty || isInsightsLoading.value) return;

    isInsightsLoading.value = true;
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey,
      );

      final txSummary = allTransactions.take(20).map((tx) {
        final date = (tx['date'] as Timestamp).toDate().toString().split(' ')[0];
        return "$date: ${tx['type']} ${tx['amount']} on ${tx['category']} (${tx['note']})";
      }).join("\n");

      final prompt = """
      You are a financial advisor. Here is a summary of the user's recent transactions:
      $txSummary
      
      Based on this data, provide 2-3 short, actionable financial insights or tips.
      Each tip must be a single, friendly sentence.
      
      Return ONLY a JSON array of strings. 
      Example:
      ["You spent 15% more on coffee this week than last week.", "Consider setting a budget for groceries."]
      """;

      final response = await model.generateContent([Content.text(prompt)]);
      
      if (response.text != null) {
        String cleanedJson = response.text!.trim();
        // Remove markdown formatting if present
        if (cleanedJson.contains('```')) {
          cleanedJson = cleanedJson.replaceAll(RegExp(r'```json|```'), '').trim();
        }
        
        final dynamic decoded = jsonDecode(cleanedJson);
        if (decoded is List) {
          aiInsights.value = decoded.map((e) => e.toString()).toList();
        }
      }
    } catch (e) {
      print('AI Insight Error: $e');
      if (aiInsights.isEmpty) {
        aiInsights.value = ["Add more transactions to see AI insights!"];
      }
    } finally {
      isInsightsLoading.value = false;
    }
  }

  void _stopListening() {
    _userSubscription?.cancel();
    _transactionSubscription?.cancel();
    user.value = null;
    allTransactions.clear();
    topExpenses.clear();
    aiInsights.clear();
    thisMonthIncome.value = 0.0;
    thisMonthExpense.value = 0.0;
  }

  Future<void> refreshAllData() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      _startListening(uid);
      await generateAiInsights();
    }
  }

  Future<void> fetchUserData() async => await refreshAllData();

  Future<void> deleteTransaction(String transactionId, double amount, String type) async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        await _firestore.collection('transactions').doc(transactionId).delete();
        if (type == 'income') {
          await _firestore.collection('users').doc(firebaseUser.uid).update({'monthlyIncome': FieldValue.increment(-amount)});
        } else {
          await _firestore.collection('users').doc(firebaseUser.uid).update({'monthlyExpense': FieldValue.increment(-amount)});
        }
      }
    } catch (e) {
      print('Error deleting transaction: $e');
    }
  }

  @override
  void onClose() {
    _stopListening();
    super.onClose();
  }
}
