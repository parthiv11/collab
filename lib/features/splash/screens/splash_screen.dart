import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to onboarding screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            const Icon(
                  Icons.handshake_outlined,
                  size: 100,
                  color: Color(0xFF007AFF),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  duration: 800.ms,
                  curve: Curves.easeInOut,
                  begin: const Offset(1, 1),
                  end: const Offset(1.05, 1.05),
                ),

            const SizedBox(height: 24),

            // App Name
            Text(
                  'Collab',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF007AFF),
                    letterSpacing: -1.5,
                  ),
                )
                .animate()
                .fade(duration: 500.ms)
                .slide(
                  begin: const Offset(0, 0.2),
                  end: const Offset(0, 0),
                  curve: Curves.easeOutQuad,
                  duration: 500.ms,
                ),

            const SizedBox(height: 12),

            // Tagline
            Text(
                  'Connect. Create. Collaborate.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[700],
                    letterSpacing: 0.2,
                  ),
                )
                .animate()
                .fade(delay: 300.ms, duration: 500.ms)
                .slide(
                  delay: 300.ms,
                  begin: const Offset(0, 0.2),
                  end: const Offset(0, 0),
                  curve: Curves.easeOutQuad,
                  duration: 500.ms,
                ),
          ],
        ),
      ),
    );
  }
}
