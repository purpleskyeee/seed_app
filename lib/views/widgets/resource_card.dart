import 'package:seed_v1/include.dart';

class ResourceCard extends StatelessWidget {
  final ResourceItem item;
  final VoidCallback? onTap;

  const ResourceCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.backgroundMint,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Badge
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(
                    item.icon,
                    color: Colors.white,
                    size: 22.0,
                  ),
                ),
                const SizedBox(height: 12.0),

                // Card Title
                Text(
                  item.title,
                  style: InterTextStyles.subtitle.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.highlightGreen,
                  ),
                ),
                const SizedBox(height: 6.0),

                // Full Description (no artificial line limit)
                Text(
                  item.description,
                  style: InterTextStyles.body.copyWith(
                    fontSize: 12.5,
                    height: 1.35,
                    color: const Color(0xFF3B523E),
                  ),
                ),
                const SizedBox(height: 14.0),
              ],
            ),

            // Tag Pill
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.highlightClay,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                item.tag,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5C3A00),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}