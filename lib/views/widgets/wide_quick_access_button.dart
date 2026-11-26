import 'package:seed_v1/include.dart';

class WideQuickAccessButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;

  const WideQuickAccessButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
          backgroundColor: AppColors.surfaceWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            // Rounded Icon Badge
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColors.backgroundMint,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(icon, color: AppColors.highlightGreen, size: 22.0),
            ),
            const SizedBox(width: 14.0),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: InterTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    subtitle,
                    style: InterTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
            ),

            // Right Chevron Arrow
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 22.0,
            ),
          ],
        ),
      ),
    );
  }
}
