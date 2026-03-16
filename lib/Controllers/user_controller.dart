import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/user_model.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var user = Rxn<UserModel>();
  var isLoading = false.obs;

  var topExpenses = <Map<String, dynamic>>[].obs;
  var allTransactions = <Map<String, dynamic>>[].obs;
  
  // New: Monthly tracking
  var thisMonthIncome = 0.0.obs;
  var thisMonthExpense = 0.0.obs;

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

  DateTime _getStartOfMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  void _startListening(String uid) {
    print('UserController: Listening for data...');

    _userSubscription?.cancel();
    _userSubscription = _firestore.collection('users').doc(uid).snapshots().listen((doc) {
      if (doc.exists) {
        user.value = UserModel.fromDocument(doc);
      }
    });

    final startOfMonth = _getStartOfMonth();
    
    _transactionSubscription?.cancel();
    _transactionSubscription = _firestore
        .collection('transactions')
        .where('userId', isEqualTo: uid)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .orderBy('date', descending: true)
        .snapshots()
        .listen((query) {
      allTransactions.value = query.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      // Reset monthly totals
      double incomeSum = 0.0;
      double expenseSum = 0.0;

      for (var tx in allTransactions) {
        double amount = double.tryParse(tx['amount'].toString()) ?? 0.0;
        if (tx['type'] == 'income') {
          incomeSum += amount;
        } else {
          expenseSum += amount;
        }
      }

      thisMonthIncome.value = incomeSum;
      thisMonthExpense.value = expenseSum;

      List<Map<String, dynamic>> expenses = allTransactions
          .where((tx) => tx['type'] == 'expense')
          .toList();
      
      expenses.sort((a, b) {
        double amountA = double.tryParse(a['amount'].toString()) ?? 0.0;
        double amountB = double.tryParse(b['amount'].toString()) ?? 0.0;
        return amountB.compareTo(amountA);
      });

      topExpenses.value = expenses.take(5).toList();
    });
  }

  void _stopListening() {
    _userSubscription?.cancel();
    _transactionSubscription?.cancel();
    user.value = null;
    allTransactions.clear();
    topExpenses.clear();
    thisMonthIncome.value = 0.0;
    thisMonthExpense.value = 0.0;
  }

  Future<void> refreshAllData() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      _startListening(uid);
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
