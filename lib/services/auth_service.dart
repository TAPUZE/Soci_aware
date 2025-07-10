import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      
      // Create user document if it doesn't exist
      if (result.user != null) {
        await _createUserDocument(result.user!);
      }
      
      return result;
    } catch (e) {
      print('Anonymous sign in failed: $e');
      return null;
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      print('Email sign in failed: $e');
      return null;
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create user document
      if (result.user != null) {
        await _createUserDocument(result.user!);
      }
      
      return result;
    } catch (e) {
      print('Account creation failed: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out failed: $e');
    }
  }

  Future<void> _createUserDocument(User user) async {
    try {
      DocumentReference userDoc = _firestore.collection('users').doc(user.uid);
      DocumentSnapshot doc = await userDoc.get();
      
      if (!doc.exists) {
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'points': 0,
          'level': 1,
          'badges': [],
          'completedQuests': [],
          'echoScore': 0.0,
          'createdAt': FieldValue.serverTimestamp(),
          'lastActive': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Failed to create user document: $e');
    }
  }

  Future<void> updateUserActivity() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'lastActive': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Failed to update user activity: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return doc.data() as Map<String, dynamic>;
        }
      }
    } catch (e) {
      print('Failed to get user data: $e');
    }
    return null;
  }
}
