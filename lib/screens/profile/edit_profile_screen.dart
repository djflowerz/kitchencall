import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  File? _pickedPhoto;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).user;
    _nameController = TextEditingController(text: user?.fullName);
    _phoneController = TextEditingController(text: user?.phone);
    _emailController = TextEditingController(text: user?.email);
  }

  Future<void> _pickPhoto() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) setState(() => _pickedPhoto = File(image.path));
    // TODO: upload the picked file to Firebase Storage / your media
    // bucket and save the resulting URL via updateProfile(photoUrl: ...)
    // once UserModel/AuthRepository support it end-to-end.
  }

  void _save() {
    ref.read(authControllerProvider.notifier).updateProfile(
          fullName: _nameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
        );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.primaryGreenLight,
                    backgroundImage: _pickedPhoto != null ? FileImage(_pickedPhoto!) : null,
                    child: _pickedPhoto == null ? const Icon(Icons.person, size: 46, color: AppColors.primaryGreen) : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: AppColors.primaryGreen,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                        onPressed: _pickPhoto,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name')),
            const SizedBox(height: 14),
            TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number')),
            const SizedBox(height: 14),
            TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 28),
            PrimaryButton(label: 'Save Changes', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
