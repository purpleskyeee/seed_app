import 'package:seed_v1/include.dart';

class AccountCreation extends StatefulWidget {
  const AccountCreation({super.key});

  @override
  State<AccountCreation> createState() => _AccountCreationState();
}

class _AccountCreationState extends State<AccountCreation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _schoolController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    final name = _nameController.text.trim();
    final school = _schoolController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your name.';
      });
      return;
    }

    if (school.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your school/school.';
      });
      return;
    }

    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      setState(() {
        _errorMessage = 'Please enter a valid email address.';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a password.';
      });
      return;
    }

    setState(() {
      _errorMessage = null; // Clear any previous error messages
    });

    _handleCreateAccount();

    // Perform account creation logic here (e.g., API call)
    // If successful, navigate to the next page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WidgetTree()),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Creation')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(200.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInput(
                      label: 'Name',
                      hintText: 'Enter your name',
                      controller: _nameController,
                    ),
                    TextInput(
                      label: 'School',
                      hintText: 'e.g. HKIS',
                      controller: _schoolController,
                    ),
                    TextInput(
                      label: 'Email',
                      hintText: 'you@example.com',
                      controller: _emailController,
                    ),
                    TextInput(
                      label: 'Password',
                      hintText: '••••••••',
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    SizedBox(height: 5.0),
                  ],
                ),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: NunitoTextStyles.subtitle.copyWith(
                      color: AppColors.highlightRed,
                    ),
                  ),
                SizedBox(height: 20.0),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.highlightRed,
                    minimumSize: Size(150, 50.0),
                  ),
                  onPressed: () {
                    _validateAndSubmit();
                  },
                  child: Text(
                    'Create Account',
                    style: NunitoTextStyles.subtitle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleCreateAccount() async {
    final name = _nameController.text.trim();
    final school = _schoolController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await credential.user?.updateDisplayName(name);

    if (name.isEmpty || email.isEmpty || password.length < 6) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance.collection('volunteers').doc(email).set({
        'name': name,
        'school': school,
        'email': email,
        'volunteerSessions': 0,
        'volunteerHours': 0,
      });

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Account creation failed')),
      );
    }
  }
}
