import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/user_model.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var user = Rxn<UserModel>();
  var isLoading = false.obs;
  
  // Observable list for top expenses
  var topExpenses = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    // 1. Initial check if user is already logged in
    if (_auth.currentUser != null) {
      refreshAllData();
    }

    // 2. Listen to Auth changes for login/logout
    _auth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        refreshAllData();
      } else {
        clearUser();
      }
    });
  }

  Future<void> refreshAllData() async {
    print('Refreshing all data for: ${_auth.currentUser?.email}');
    await fetchUserData();
    await fetchTopExpenses();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (doc.exists) {
          user.value = UserModel.fromDocument(doc);
          print('User data fetched: ${user.value?.fullName}');
        } else {
          print('User document does not exist in Firestore');
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
        print('Fetching top expenses for UID: ${firebaseUser.uid}');
        
        // Try the specific query first
        QuerySnapshot query = await _firestore
            .collection('transactions')
            .where('userId', isEqualTo: firebaseUser.uid)
            .where('type', isEqualTo: 'expense') 
            .orderBy('amount', descending: true)
            .limit(5)
            .get();

        print('Found ${query.docs.length} expenses');
        
        // Fallback: If empty, maybe the 'type' field is missing in older transactions
        if (query.docs.isEmpty) {
          print('No specific "expense" types found, trying general query...');
          query = await _firestore
              .collection('transactions')
              .where('userId', isEqualTo: firebaseUser.uid)
              .orderBy('amount', descending: true)
              .limit(5)
              .get();
          
          // Filter out income locally if type field exists but isn't 'expense'
          topExpenses.value = query.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .where((data) => data['type'] != 'income')
              .toList();
        } else {
          topExpenses.value = query.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        }
      }
    } catch (e) {
      print('Error fetching top expenses: $e');
      
      // If there's an index error, try an even simpler query as a safe fallback
      try {
        final firebaseUser = _auth.currentUser;
        if (firebaseUser != null) {
           QuerySnapshot simpleQuery = await _firestore
              .collection('transactions')
              .where('userId', isEqualTo: firebaseUser.uid)
              .limit(10)
              .get();
           
           print('Simplified fallback found ${simpleQuery.docs.length} docs');
           topExpenses.value = simpleQuery.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .where((data) => data['type'] != 'income')
              .toList();
        }
      } catch (e2) {
        print('Ultimate fallback failed: $e2');
      }
    }
  }

  void clearUser() {
    user.value = null;
    topExpenses.clear();
  }
}
