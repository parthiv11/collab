import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../features/auth/providers/auth_provider.dart' as auth;

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Get a reference to the user document
  DocumentReference get userDocument =>
      _firestore.collection('users').doc(currentUserId);

  // Get user data
  Future<auth.User?> getUserData() async {
    if (currentUserId == null) return null;

    try {
      DocumentSnapshot doc = await userDocument.get();
      if (doc.exists) {
        return auth.User.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Save user data
  Future<bool> saveUserData(auth.User user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
      return true;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  // Update user data
  Future<bool> updateUserData(Map<String, dynamic> data) async {
    if (currentUserId == null) return false;

    try {
      await userDocument.update(data);
      return true;
    } catch (e) {
      print('Error updating user data: $e');
      return false;
    }
  }

  // Create a collection reference with user-specific data
  CollectionReference userCollection(String collectionPath) {
    if (currentUserId == null) {
      throw Exception('User is not authenticated');
    }
    return _firestore.collection('users/$currentUserId/$collectionPath');
  }

  // Add a document to a collection
  Future<DocumentReference?> addDocument(
    String collectionPath,
    Map<String, dynamic> data,
  ) async {
    try {
      return await userCollection(collectionPath).add({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding document: $e');
      return null;
    }
  }

  // Update a document
  Future<bool> updateDocument(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      await userCollection(collectionPath).doc(documentId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error updating document: $e');
      return false;
    }
  }

  // Delete a document
  Future<bool> deleteDocument(String collectionPath, String documentId) async {
    try {
      await userCollection(collectionPath).doc(documentId).delete();
      return true;
    } catch (e) {
      print('Error deleting document: $e');
      return false;
    }
  }

  // Get a document
  Future<DocumentSnapshot?> getDocument(
    String collectionPath,
    String documentId,
  ) async {
    try {
      return await userCollection(collectionPath).doc(documentId).get();
    } catch (e) {
      print('Error getting document: $e');
      return null;
    }
  }

  // Get all documents in a collection
  Stream<QuerySnapshot> streamDocuments(String collectionPath) {
    return userCollection(
      collectionPath,
    ).orderBy('createdAt', descending: true).snapshots();
  }
}
