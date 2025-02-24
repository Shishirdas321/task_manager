import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/forgot_password_verify_otp_screen.dart';
import 'package:task_manager/ui/utills/app_colors.dart';
import 'package:task_manager/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/widgets/screen_background.dart';

import '../../data/models/services/network_caller.dart';
import '../../data/utills/urls.dart';
import '../../widgets/snack_bar_message.dart';

class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({super.key});

  static const String name = '/forgot-password-verify-email';

  @override
  State<ForgotPasswordVerifyEmailScreen> createState() =>
      _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState
    extends State<ForgotPasswordVerifyEmailScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  bool _recoveryEmailInProgress = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text('Your Email Address', style: textTheme.titleLarge),
                  //aro style add korte caile titleLarge ar pore ?.copyWith(color: Colors.blue)
                  const SizedBox(height: 4),
                   Text(
                    'A 6 digits of OTP will be sent to your email address',
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Visibility(
                    visible: _recoveryEmailInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapEmailRecovery,
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Center(
                    child: _buildSignInSection(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
        text: " have an account?",
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: 'Sign in',
            style: const TextStyle(
              color: AppColors.themeColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pop(context);
              },
          )
        ],
      ),
    );
  }

  void _onTapEmailRecovery() {
    if (_formKey.currentState!.validate()) {
      _getRecoveryEmail();
    }
  }

  Future<void> _getRecoveryEmail() async {
    _recoveryEmailInProgress = true;
    setState(() {});
    final email = _emailTEController.text;
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.recoveryVerifyEmailUrl(email));
    if (response.isSuccess) {
      Navigator.pushNamed(context, ForgotPasswordVerifyOtpScreen.name,
          arguments: email);
      showSnackBarMessage(context, 'Email verify successful');
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _recoveryEmailInProgress = false;
    setState(() {});
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
