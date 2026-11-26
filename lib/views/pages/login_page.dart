import 'package:seed_v1/include.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

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

    _handleLogin();
    // Perform login logic here (e.g., API call)
    // If successful, navigate to the next page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WidgetTree()),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
                  child: Text('Log In', style: NunitoTextStyles.subtitle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      AuthGate.refreshAuth();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message ?? 'Login failed')));
      }
    }
  }
}
