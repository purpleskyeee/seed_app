import 'package:seed_v1/include.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset("assets/lotties/grow.json"),
            Text(
              'Welcome to SEED!',
              style: NunitoTextStyles.title.copyWith(color:AppColors.textPrimary,fontSize: 30.0),
            ),
            SizedBox(height: 20.0),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.highlightRed,
                minimumSize: Size(350.0, 85.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AccountCreation();
                    },
                  ),
                );
              },
              child: Text('Get Started', style: NunitoTextStyles.title.copyWith(color:AppColors.surfaceWhite)),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginPage();
                    },
                  ),
                );
              },
              child: Text(
                'Already have an account? Log in',
                style: InterTextStyles.body.copyWith(color:AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
