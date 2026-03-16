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

  @override
  void onInit() {
    super.onInit();
    
    if (_auth.currentUser != null) {
      refreshAllData();
    }

    _auth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        refreshAllData();
      } else {
        clearUser();
      }
    });
  }

  Future<void> refreshAllData() async {
    await fetchUserData();
    await fetchTopExpenses();
    await fetchAllTransactions();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (doc.exists) {
          user.value = UserModel.fromDocument(doc);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTopExpenses() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        QuerySnapshot query = await _firestore
            .collection('transactions')
            .where('userId', isEqualTo: firebaseUser.uid)
            .where('type', isEqualTo: 'expense') 
            .orderBy('amount', descending: true)
            .limit(5)
            .get();

        if (query.docs.isEmpty) {
          query = await _firestore
              .collection('transactions')
              .where('userId', isEqualTo: firebaseUser.uid)
              .orderBy('amount', descending: true)
              .limit(5)
              .get();
          
          topExpenses.value = query.docs
              .map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                data['id'] = doc.id; // Include doc ID
                return data;
              })
              .where((data) => data['type'] != 'income')
              .toList();
        } else {
          topExpenses.value = query.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();
        }
      }
    } catch (e) {
      print('Error fetching top expenses: $e');
    }
  }

  Future<void> fetchAllTransactions() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        QuerySnapshot query = await _firestore
            .collection('transactions')
            .where('userId', isEqualTo: firebaseUser.uid)
            .orderBy('date', descending: true)
            .get();

        allTransactions.value = query.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
      }
    } catch (e) {
      print('Error fetching all transactions: $e');
    }
  }

  Future<void> deleteTransaction(String transactionId, double amount, String type) async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        // 1. Delete the transaction document
        await _firestore.collection('transactions').doc(transactionId).delete();

        // 2. Adjust the user's totals
        if (type == 'income') {
          await _firestore.collection('users').doc(firebaseUser.uid).update({
            'monthlyIncome': FieldValue.increment(-amount),
          });
        } else {
          await _firestore.collection('users').doc(firebaseUser.uid).update({
            'monthlyExpense': FieldValue.increment(-amount),
          });
        }

        // 3. Refresh data
        await refreshAllData();
      }
    } catch (e) {
      print('Error deleting transaction: $e');
      rethrow;
    }
  }

  void clearUser() {
    user.value = null;
    topExpenses.clear();
    allTransactions.clear();
  }
}
