import 'package:seed_v1/include.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _schoolController;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: Userinfo.username.value);
    _schoolController = TextEditingController(text: Userinfo.school.value);
    _bioController = TextEditingController(text: Userinfo.bio.value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _schoolController.dispose();
    _bioController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignOut() async {
    await Userinfo.stopListening();
    await AdminStore.stopListening();
    await Future.delayed(const Duration(milliseconds: 50));
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomePage()),
    );
  }

  Future<void> _saveChanges() async {
    final name = _nameController.text.trim();
    final school = _schoolController.text.trim();
    final bio = _bioController.text.trim();
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty) {
      _showMessage('Full name cannot be empty.');
      return;
    }

    if (newPassword.isNotEmpty) {
      if (newPassword.length < 6) {
        _showMessage('New password must be at least 6 characters.');
        return;
      }
      if (newPassword != confirmPassword) {
        _showMessage('New passwords do not match.');
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      final email = Userinfo.email.value;
      if (email.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('volunteers')
            .doc(email)
            .set({
              'name': name,
              'school': school,
              'bio': bio,
            }, SetOptions(merge: true));
      }

      if (newPassword.isNotEmpty) {
        await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }

      if (!mounted) return;
      _showMessage('Changes saved.');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showMessage(
        e.code == 'requires-recent-login'
            ? 'Please sign out and sign back in before changing your password.'
            : (e.message ?? 'Could not update password.'),
      );
    } catch (_) {
      if (!mounted) return;
      _showMessage('Failed to save changes.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration _fieldDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: InterTextStyles.body.copyWith(
        color: const Color(0xFF9E988F),
        fontSize: 14.0,
      ),
      filled: true,
      fillColor: AppColors.canvasCream,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14.0,
        vertical: 14.0,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.textPrimary, width: 1.3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 200.0,
            vertical: 50.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.only(
                        right: 10.0,
                        top: 4.0,
                        bottom: 4.0,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary,
                        size: 20.0,
                      ),
                    ),
                  ),
                  Text(
                    'Settings',
                    style: NunitoTextStyles.title.copyWith(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Text(
                'Adjust Your Preferences.',
                style: InterTextStyles.body.copyWith(
                  fontSize: 14.0,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24.0),

              // PROFILE DETAILS
              Text(
                'PROFILE DETAILS',
                style: InterTextStyles.body.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: const Color(0xFF7B756C),
                ),
              ),
              const SizedBox(height: 14.0),

              Text(
                'Full name',
                style: InterTextStyles.subtitle.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6.0),
              TextField(
                controller: _nameController,
                decoration: _fieldDecoration(),
              ),
              const SizedBox(height: 16.0),

              Text(
                'School or organisation',
                style: InterTextStyles.subtitle.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6.0),
              TextField(
                controller: _schoolController,
                decoration: _fieldDecoration(),
              ),
              const SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'About me',
                    style: InterTextStyles.subtitle.copyWith(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${_bioController.text.length}/400',
                    style: InterTextStyles.body.copyWith(
                      fontSize: 12.0,
                      color: const Color(0xFF8C857B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              TextField(
                controller: _bioController,
                maxLength: 400,
                maxLines: 5,
                onChanged: (_) => setState(() {}),
                decoration: _fieldDecoration().copyWith(counterText: ''),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Divider(color: Color(0xFFE3DAC9), thickness: 1.0),
              ),

              // CHANGE PASSWORD
              Text(
                'Change password',
                style: InterTextStyles.title.copyWith(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14.0),

              Text(
                'New password',
                style: InterTextStyles.subtitle.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6.0),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: _fieldDecoration(
                  hintText: 'Leave blank to keep your password',
                ),
              ),
              const SizedBox(height: 16.0),

              Text(
                'Confirm new password',
                style: InterTextStyles.subtitle.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6.0),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: _fieldDecoration(),
              ),
              const SizedBox(height: 22.0),

              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8521A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save changes',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 28.0),

              // ACCOUNT / SIGN OUT
              Text(
                'ACCOUNT',
                style: InterTextStyles.body.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: const Color(0xFF7B756C),
                ),
              ),
              const SizedBox(height: 10.0),

              Material(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: _handleSignOut,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Container(
                          width: 42.0,
                          height: 42.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6EFE7),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            color: Color(0xFFD94336),
                            size: 20.0,
                          ),
                        ),
                        const SizedBox(width: 14.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sign out',
                                style: InterTextStyles.subtitle.copyWith(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                'Return to the welcome screen',
                                style: InterTextStyles.body.copyWith(
                                  fontSize: 12.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
