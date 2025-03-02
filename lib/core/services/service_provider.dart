import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firestore_service.dart';

/// ServiceProvider is a utility class that provides a way to access
/// various services throughout the app.
class ServiceProvider extends StatelessWidget {
  final Widget child;

  const ServiceProvider({Key? key, required this.child}) : super(key: key);

  /// Get the FirestoreService instance
  static FirestoreService firestoreOf(BuildContext context) {
    return Provider.of<FirestoreService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirestoreService>(create: (_) => FirestoreService()),
      ],
      child: child,
    );
  }
}
