import 'package:seed_v1/include.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'V';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
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
              Text(
                'My Volunteer Profile',
                style: NunitoTextStyles.title.copyWith(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 18.0),

              // Green Volunteer Hero Card + Stats
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: AppColors.backgroundMint,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ValueListenableBuilder<String>(
                          valueListenable: Userinfo.username,
                          builder: (context, name, _) {
                            return CircleAvatar(
                              radius: 30.0,
                              backgroundColor: AppColors.primaryGreen,
                              child: Text(
                                _getInitials(name),
                                style: NunitoTextStyles.title.copyWith(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ValueListenableBuilder<String>(
                                valueListenable: Userinfo.username,
                                builder: (context, name, _) {
                                  return Text(
                                    name.isEmpty ? 'Volunteer' : name,
                                    style: NunitoTextStyles.title.copyWith(
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 3.0),
                              ValueListenableBuilder<String>(
                                valueListenable: Userinfo.school,
                                builder: (context, school, _) {
                                  if (school.trim().isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text(
                                    school,
                                    style: InterTextStyles.body.copyWith(
                                      fontSize: 13.0,
                                      color: AppColors.highlightGreen,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 2.0),
                              ValueListenableBuilder<String>(
                                valueListenable: Userinfo.email,
                                builder: (context, email, _) {
                                  return Text(
                                    email,
                                    style: InterTextStyles.body.copyWith(
                                      fontSize: 12.0,
                                      color: AppColors.textSecondary,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18.0),
                    Row(
                      children: [
                        Expanded(
                          child: _HeroStatBox(
                            label: 'Hours',
                            notifier: Userinfo.volunteerHours,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: _HeroStatBox(
                            label: 'Sessions',
                            notifier: Userinfo.volunteerSessions,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: _HeroStatBox(
                            label: 'Students',
                            notifier: Userinfo.studentsAssigned,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // ASSIGNED STUDENTS SECTION
              Text(
                'ASSIGNED STUDENTS',
                style: InterTextStyles.body.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: const Color(0xFF7B756C),
                ),
              ),
              const SizedBox(height: 12.0),
              ValueListenableBuilder<String>(
                valueListenable: Userinfo.username,
                builder: (context, currentName, _) {
                  return ValueListenableBuilder<List<AdminStudent>>(
                    valueListenable: AdminStore.students,
                    builder: (context, allStudents, _) {
                      return ValueListenableBuilder<List<SessionSlot>>(
                        valueListenable: AdminStore.sessions,
                        builder: (context, allSessions, _) {
                          final normalizedUser = currentName
                              .trim()
                              .toLowerCase();
                          final myStudents = normalizedUser.isEmpty
                              ? <AdminStudent>[]
                              : allStudents
                                    .where(
                                      (s) =>
                                          (s.assignedVolunteer ?? '')
                                              .trim()
                                              .toLowerCase() ==
                                          normalizedUser,
                                    )
                                    .toList();

                          if (myStudents.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18.0),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceWhite,
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: Text(
                                'No students assigned to you yet.',
                                style: InterTextStyles.body.copyWith(
                                  fontSize: 13.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: myStudents.map((student) {
                              final sessionCount = allSessions
                                  .where(
                                    (slot) =>
                                        (slot.studentName ?? '')
                                            .trim()
                                            .toLowerCase() ==
                                        student.name.trim().toLowerCase(),
                                  )
                                  .length;
                              final subtitle =
                                  '${student.grade} · $sessionCount ${sessionCount == 1 ? 'session' : 'sessions'}';

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _AssignedStudentTile(
                                  student: student,
                                  subtitle: subtitle,
                                ),
                              );
                            }).toList(),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 14.0),

              // ABOUT ME SECTION
              Text(
                'ABOUT ME',
                style: InterTextStyles.body.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: const Color(0xFF7B756C),
                ),
              ),
              const SizedBox(height: 12.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ValueListenableBuilder<String>(
                  valueListenable: Userinfo.bio,
                  builder: (context, bio, _) {
                    final hasBio = bio.trim().isNotEmpty;
                    return Text(
                      hasBio ? bio : 'No bio added yet. Tap Settings below to share a short introduction.',
                      style: InterTextStyles.body.copyWith(
                        fontSize: 13.5,
                        height: 1.45,
                        color: hasBio
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18.0),

              // SETTINGS NAVIGATION CARD
              Material(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(20.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.0),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 42.0,
                          height: 42.0,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundMint,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Icon(
                            Icons.settings_outlined,
                            color: AppColors.highlightGreen,
                            size: 21.0,
                          ),
                        ),
                        const SizedBox(width: 14.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Settings',
                                style: InterTextStyles.subtitle.copyWith(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                'Appearance, administration, and account',
                                style: InterTextStyles.body.copyWith(
                                  fontSize: 12.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.textSecondary,
                          size: 22.0,
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

class _HeroStatBox extends StatelessWidget {
  final String label;
  final ValueNotifier<int> notifier;

  const _HeroStatBox({required this.label, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          ValueListenableBuilder<int>(
            valueListenable: notifier,
            builder: (context, value, _) {
              return Text(
                '$value',
                style: NunitoTextStyles.title.copyWith(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),
          const SizedBox(height: 2.0),
          Text(
            label,
            style: InterTextStyles.body.copyWith(
              fontSize: 12.5,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssignedStudentTile extends StatelessWidget {
  final AdminStudent student;
  final String subtitle;

  const _AssignedStudentTile({required this.student, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 5.0),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 21.0,
                backgroundColor: AppColors.primaryGreen,
                child: Text(
                  student.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: InterTextStyles.subtitle.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      subtitle,
                      style: InterTextStyles.body.copyWith(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 5.0,
                ),
                decoration: BoxDecoration(
                  color: AdminStore.levelBgColor(student.level),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  student.level,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: AdminStore.levelTextColor(student.level),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
