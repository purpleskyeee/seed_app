import 'package:seed_v1/include.dart';

class NextSessionsSection extends StatelessWidget {
  const NextSessionsSection({super.key});

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Userinfo.username,
      builder: (context, currentVolunteerName, _) {
        return ValueListenableBuilder<List<SessionSlot>>(
          valueListenable: AdminStore.sessions,
          builder: (context, allSessions, _) {
            final normalizedUser = currentVolunteerName.trim().toLowerCase();
            final mySessions = normalizedUser.isEmpty
                ? <SessionSlot>[]
                : allSessions.where((slot) {
                    return (slot.volunteerName ?? '').trim().toLowerCase() ==
                        normalizedUser;
                  }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mySessions.length > 1 ? 'NEXT SESSIONS' : 'NEXT SESSION',
                  style: InterTextStyles.body.copyWith(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: const Color(0xFF7B756C),
                  ),
                ),
                const SizedBox(height: 12.0),
                if (mySessions.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      'No sessions assigned to you yet.',
                      style: InterTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13.5,
                      ),
                    ),
                  )
                else
                  ...mySessions.map(
                    (slot) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _SessionCard(
                        slot: slot,
                        initials: _getInitials(slot.studentName ?? ''),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _SessionCard extends StatelessWidget {
  final SessionSlot slot;
  final String initials;

  const _SessionCard({
    required this.slot,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    final hasStudent =
        slot.studentName != null && slot.studentName!.trim().isNotEmpty;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 5.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 23.0,
                backgroundColor: AppColors.primaryGreen,
                child: hasStudent
                    ? Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                        ),
                      )
                    : const Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white,
                        size: 19.0,
                      ),
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasStudent ? slot.studentName!.trim() : 'Open Session',
                      style: InterTextStyles.subtitle.copyWith(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      '${slot.nextDate} · ${slot.time} · ${slot.room}',
                      style: InterTextStyles.body.copyWith(
                        fontSize: 13.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}