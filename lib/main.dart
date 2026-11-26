import 'package:seed_v1/include.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: lightModeNotifier,
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.canvasCream,
            colorScheme: const ColorScheme.light(
              surface: AppColors.backgroundMint,
              primary: AppColors.primaryGreen,
              onPrimary: AppColors.surfaceWhite,
              onSurface: AppColors.textPrimary,
            ),
          ),
          home: const AuthGate(),
        );
      },
    );
  }
}

final ValueNotifier<User?> authUserNotifier = ValueNotifier<User?>(
  FirebaseAuth.instance.currentUser,
);

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  static void refreshAuth() {
    final user = FirebaseAuth.instance.currentUser;
    authUserNotifier.value = user;
    if (user != null && user.email != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AdminStore.startListening();
        Userinfo.startListening(user.email!);
      });
    }
  }

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    AuthGate.refreshAuth();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<User?>(
      valueListenable: authUserNotifier,
      builder: (context, user, _) {
        return user != null ? const WidgetTree() : const WelcomePage();
      },
    );
  }
}
