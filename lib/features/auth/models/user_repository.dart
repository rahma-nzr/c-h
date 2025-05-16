import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_hire/features/auth/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createUser(UserModel user) async {
    try {
      // Create auth user first
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      
      // Then save additional user data to Firestore (without password)
      await _firestore.collection('users').doc(credential.user?.uid).set(
        user.copyWith(id: credential.user?.uid, password: '').toJson()
      );
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;
    
    final snapshot = await _firestore.collection('users').doc(userId).get();
    if (snapshot.exists) {
      return UserModel.fromJson(snapshot.data()!);
    }
    return null;
  }

  Future<void> updateUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.id).update(user.toJson());
  }
}