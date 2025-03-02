import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../providers/auth_provider.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _resendSeconds = 30;
  Timer? _timer;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() {
      _resendSeconds = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() {
          _resendSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _getOtp() {
    return _controllers.map((controller) => controller.text).join();
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {
      _error = null;
    });
  }

  void _pasteOtp(String text) {
    if (text.length == 6 && int.tryParse(text) != null) {
      for (var i = 0; i < 6; i++) {
        _controllers[i].text = text[i];
      }
      // Move focus to the last field
      _focusNodes[5].requestFocus();
      setState(() {
        _error = null;
      });
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _getOtp();
    if (otp.length != 6) {
      setState(() {
        _error = 'Please enter all 6 digits';
      });
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.verifyOTP(otp);

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.profileCreation);
    } else if (mounted) {
      setState(() {
        _error = authProvider.error ?? 'Verification failed';
      });
    }
  }

  void _resendOtp() {
    if (_resendSeconds == 0) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // Clear all fields
      for (var controller in _controllers) {
        controller.clear();
      }
      // Focus on first field
      _focusNodes[0].requestFocus();
      // Reset error
      setState(() {
        _error = null;
      });
      // Restart timer
      _startResendTimer();
      // Call API to resend OTP (mock)
      authProvider.signInWithPhone('resend');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Verification')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Enter Verification Code',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'We\'ve sent a 6-digit code to your mobile number',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
              ),

              const SizedBox(height: 48),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 45,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color:
                                _error != null
                                    ? Colors.red
                                    : Theme.of(context).dividerTheme.color!,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color:
                                _error != null
                                    ? Colors.red
                                    : Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) => _onOtpChanged(index, value),
                      onFieldSubmitted: (_) {
                        if (index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Error message
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Paste button
              Center(
                child: TextButton(
                  onPressed: () async {
                    final data = await Clipboard.getData('text/plain');
                    if (data?.text != null) {
                      _pasteOtp(data!.text!);
                    }
                  },
                  child: Text(
                    'Paste from clipboard',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Verify button
              ElevatedButton(
                onPressed: authProvider.isLoading ? null : _verifyOtp,
                child:
                    authProvider.isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text('Verify'),
              ),

              const SizedBox(height: 24),

              // Resend code
              Center(
                child: TextButton(
                  onPressed: _resendSeconds == 0 ? _resendOtp : null,
                  child: Text(
                    _resendSeconds > 0
                        ? 'Resend code in $_resendSeconds seconds'
                        : 'Resend code',
                    style: TextStyle(
                      color:
                          _resendSeconds > 0
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Info text
              Center(
                child: Text(
                  'Use code 123456 for demo',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
