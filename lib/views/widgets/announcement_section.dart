import 'package:seed_v1/include.dart';

class AnnouncementsSection extends StatelessWidget {
  const AnnouncementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<AnnouncementItem>>(
      valueListenable: AdminStore.announcements,
      builder: (context, allAnnouncements, _) {
        final pinned = allAnnouncements.where((a) => a.isPinned).toList();
        final newestUnpinned =
            allAnnouncements.where((a) => !a.isPinned).take(1).toList();

        final displayedAnnouncements = [...pinned, ...newestUnpinned];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ANNOUNCEMENTS',
              style: InterTextStyles.body.copyWith(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: const Color(0xFF7B756C),
              ),
            ),
            const SizedBox(height: 12.0),
            if (displayedAnnouncements.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'No announcements right now.',
                  style: InterTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13.5,
                  ),
                ),
              )
            else
              ...displayedAnnouncements.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _AnnouncementCard(item: item),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final AnnouncementItem item;

  const _AnnouncementCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      width: double.infinity,
      margin: item.isPinned ? const EdgeInsets.only(left: 5.0) : EdgeInsets.zero,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (item.isPinned) ...[
                const Icon(
                  Icons.push_pin_outlined,
                  size: 16.0,
                  color: Color(0xFF9C6B19),
                ),
                const SizedBox(width: 8.0),
              ],
              Expanded(
                child: Text(
                  item.title,
                  style: InterTextStyles.subtitle.copyWith(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Text(
            item.body,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: InterTextStyles.body.copyWith(
              fontSize: 13.5,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );

    if (!item.isPinned) return cardContent;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.highlightClay,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        cardContent,
      ],
    );
  }
}