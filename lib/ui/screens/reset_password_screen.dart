import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utills/app_colors.dart';
import 'package:task_manager/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/widgets/screen_background.dart';

import '../../data/models/services/network_caller.dart';
import '../../data/utills/urls.dart';
import '../../widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.otp, required this.email});

  final String otp;
  final String email;

  static const String name = '/forgot-password/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController =
      TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _resetPasswordInProgress = false;

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
                  Text('Set Password', style: textTheme.titleLarge),
                  //aro style add korte caile titleLarge ar pore ?.copyWith(color: Colors.blue)
                  const SizedBox(height: 4),
                   Text(
                    'Minimum length of password should be more then 8 letters.',
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _newPasswordTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'New Password'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your password';
                      }else if(value!.length<6){
                        return 'Password must be more then 6 letters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration:
                        const InputDecoration(hintText: 'Confirm New Password'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your confirm password';
                      }else if(value!.length<6){
                        return 'Password must be more then 6 letters';
                      }else if(value != _newPasswordTEController.text){
                        return 'Password do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Visibility(
                    visible: _resetPasswordInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapResetPassword,
                      child: const Text('Confirm'),
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
                Navigator.pushNamedAndRemoveUntil(
                    context, SignInScreen.name, (value) => false);
              },
          )
        ],
      ),
    );
  }

  void _onTapResetPassword() {
    if (_formKey.currentState!.validate()) {
      _resetPassword();
    }
  }

  Future<void> _resetPassword() async {
    _resetPasswordInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": _newPasswordTEController.text,
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.recoverPasswordUrl, body: requestBody);
    if (response.isSuccess) {
      showSnackBarMessage(context, 'password reset successful');
      Navigator.pushNamedAndRemoveUntil(
          context, SignInScreen.name, (predicate) => false);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _resetPasswordInProgress = false;
    setState(() {});
  }

  @override
  void dispose() {
    _newPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
