import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../providers/auth_provider.dart';
import '../models/country_code.dart';
import '../widgets/country_code_dropdown.dart';
import '../utils/phone_number_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPhoneValid = false;
  CountryCode _selectedCountryCode = CountryCode.getCommonCountries()
      .firstWhere(
        (c) => c.code == 'US',
        orElse: () => CountryCode.getCommonCountries().first,
      );

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _updatePhoneValidation(String value) {
    setState(() {
      _isPhoneValid = PhoneNumberHelper.isValidPhoneNumber(
        value,
        _selectedCountryCode,
      );
    });
  }

  void _onCountryChanged(CountryCode countryCode) {
    setState(() {
      _selectedCountryCode = countryCode;
      // Revalidate phone number with new country code
      _updatePhoneValidation(_phoneController.text);
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Format phone number to E.164 format
    final formattedPhoneNumber = PhoneNumberHelper.formatToE164(
      _phoneController.text,
      _selectedCountryCode,
    );

    final success = await authProvider.signInWithPhone(formattedPhoneNumber);

    if (success && mounted) {
      Navigator.pushNamed(context, AppRoutes.verification);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userType = authProvider.selectedUserType;
    String userTypeText = '';

    switch (userType) {
      case UserType.influencer:
        userTypeText = 'Influencer';
        break;
      case UserType.brand:
        userTypeText = 'Brand';
        break;
      case UserType.business:
        userTypeText = 'Business';
        break;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Login as $userTypeText')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Welcome back!',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your mobile number to continue',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                ),

                const SizedBox(height: 48),

                // User type selector
                Text(
                  'Account Type',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                // User type options
                Row(
                  children: [
                    _buildUserTypeOption(
                      context,
                      UserType.influencer,
                      'Influencer',
                      Icons.person,
                    ),
                    const SizedBox(width: 12),
                    _buildUserTypeOption(
                      context,
                      UserType.brand,
                      'Brand',
                      Icons.shopping_bag,
                    ),
                    const SizedBox(width: 12),
                    _buildUserTypeOption(
                      context,
                      UserType.business,
                      'Business',
                      Icons.business,
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Phone input
                Text(
                  'Mobile Number',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                // Country code and phone input row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CountryCodeDropdown(
                      initialSelection: _selectedCountryCode,
                      onChanged: _onCountryChanged,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Phone number',
                          prefixIcon: Icon(Icons.phone_android),
                        ),
                        onChanged: _updatePhoneValidation,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          return PhoneNumberHelper.getValidationError(
                            value ?? '',
                            _selectedCountryCode,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Text(
                  'We\'ll send a verification code to this number',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 32),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _isPhoneValid && !authProvider.isLoading
                            ? _login
                            : null,
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
                            : const Text('Continue'),
                  ),
                ),

                const SizedBox(height: 16),

                // Error message
                if (authProvider.error != null)
                  Text(
                    authProvider.error!,
                    style: const TextStyle(color: Colors.red),
                  ),

                const SizedBox(height: 24),

                // Terms and conditions
                Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeOption(
    BuildContext context,
    UserType type,
    String label,
    IconData icon,
  ) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isSelected = authProvider.selectedUserType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          authProvider.setUserType(type);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.grey,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color:
                      isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
