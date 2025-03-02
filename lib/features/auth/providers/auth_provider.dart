import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum UserType { influencer, brand, business }

class User {
  final String id;
  final String name;
  final String? email;
  final String phone;
  final UserType userType;
  final String? profileImage;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    required this.userType,
    this.profileImage,
    this.isVerified = false,
  });

  // Convert User to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType.toString().split('.').last,
      'profileImage': profileImage,
      'isVerified': isVerified,
    };
  }

  // Create User from a Firestore document
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return User(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'],
      phone: data['phone'] ?? '',
      userType: _getUserTypeFromString(data['userType'] ?? ''),
      profileImage: data['profileImage'],
      isVerified: data['isVerified'] ?? false,
    );
  }

  // Helper method to convert string to UserType enum
  static UserType _getUserTypeFromString(String userTypeString) {
    return UserType.values.firstWhere(
      (e) => e.toString().split('.').last == userTypeString,
      orElse: () => UserType.influencer,
    );
  }
}

class AuthProvider extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  UserType _selectedUserType = UserType.influencer;
  String? _verificationId;

  // Store the phone number for dummy implementation
  String? _phoneNumber;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get error => _error;
  UserType get selectedUserType => _selectedUserType;

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error
  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Set user type
  void setUserType(UserType userType) {
    _selectedUserType = userType;
    notifyListeners();
  }

  // Sign in with phone (dummy implementation)
  Future<bool> signInWithPhone(String phoneNumber) async {
    setLoading(true);
    setError(null);

    try {
      // Store the phone number for later use
      _phoneNumber = phoneNumber;

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Set a dummy verification ID
      _verificationId = 'dummy-verification-id';

      setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      setError('Failed to sign in: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  // Verify OTP (dummy implementation)
  Future<bool> verifyOTP(String otp) async {
    setLoading(true);
    setError(null);

    try {
      // For testing purposes, any 6-digit OTP is considered valid
      if (otp.length != 6 || int.tryParse(otp) == null) {
        setError('Invalid OTP. Please enter a 6-digit code.');
        setLoading(false);
        return false;
      }

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate user ID
      const dummyUserId = 'dummy-user-id-123456';

      // Check if user profile exists in Firestore (skip for now)
      // In a real app, you would create or check for a user in Firestore

      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to verify OTP: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  // Complete profile creation
  Future<bool> createProfile({
    required String name,
    required String phone,
    String? email,
    String? profileImage,
  }) async {
    setLoading(true);
    setError(null);

    try {
      // Create dummy user data with the user-provided info
      final userData = User(
        id: 'dummy-user-id-123456', // Use a fixed ID for testing
        name: name,
        phone: phone,
        email: email,
        userType: _selectedUserType,
        profileImage: profileImage,
        isVerified: true,
      );

      // In a real app, you would save this to Firestore
      // For now, just update the current user
      _currentUser = userData;

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      setError('Failed to create profile: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    setLoading(true);
    try {
      // No need to call Firebase auth signOut
      // Just reset the local state
      _currentUser = null;
      _phoneNumber = null;
      _verificationId = null;

      await Future.delayed(const Duration(milliseconds: 500));

      notifyListeners();
    } catch (e) {
      setError('Failed to sign out: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }
}
