import 'package:seed_v1/include.dart';

class QuickAccessButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const QuickAccessButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115.0,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.surfaceWhite,
          elevation: 0,
          padding: const EdgeInsets.all(25.0),
          alignment: Alignment.topLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFC4E0C7),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(icon, color: const Color(0xFF3B6E44), size: 22.0),
            ),
            SizedBox(height: 15.0),
            Text(
              title,
              style: InterTextStyles.body.copyWith(
                color: const Color(0xFF2C322B),
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
