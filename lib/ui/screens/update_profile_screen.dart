import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/models/services/network_caller.dart';
import 'package:task_manager/data/utills/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/widgets/screen_background.dart';
import 'package:task_manager/widgets/snack_bar_message.dart';
import 'package:task_manager/widgets/tm_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstnameTEController = TextEditingController();
  final TextEditingController _lastnameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  bool _updateProfileInProgress = false;

  @override
  void initState() {
    super.initState();
    _emailTEController.text = AuthController.userModel?.email ?? '';
    _firstnameTEController.text = AuthController.userModel?.firstName ?? '';
    _lastnameTEController.text = AuthController.userModel?.lastName ?? '';
    _mobileTEController.text = AuthController.userModel?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const TMAppBar(
        fromUpdateProfile: true,
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text('Update Profile', style: textTheme.titleLarge),
                  //aro style add korte caile titleLarge ar pore ?.copyWith(color: Colors.blue)
                  const SizedBox(height: 24),
                  _buildPhotoPicker(),
                  const SizedBox(height: 8),
                  TextFormField(
                    enabled: false,
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _firstnameTEController,
                    decoration: const InputDecoration(
                      hintText: 'First name',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastnameTEController,
                    decoration: const InputDecoration(
                      hintText: 'Last name',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _mobileTEController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Mobile',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),
                  Visibility(
                    visible: _updateProfileInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapUpdateButton,
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Photo',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _pickedImage == null ? 'No item selected' : _pickedImage!.name,
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = image;
      setState(() {});
    }
  }

  void _onTapUpdateButton() {
    if (_globalKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstnameTEController.text.trim(),
      "lastName": _lastnameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
    };

    if (_pickedImage != null) {
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      requestBody['photo'] = base64Encode(imageBytes);
    }
    if (_passwordTEController.text.isNotEmpty) {
      requestBody['password'] = _passwordTEController.text;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.updateProfile, body: requestBody);
    _updateProfileInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _passwordTEController.clear();
      showSnackBarMessage(context, 'profile update successful');
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstnameTEController.dispose();
    _lastnameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
