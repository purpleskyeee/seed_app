import 'package:seed_v1/include.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 200.0,
            vertical: 50.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (DateTime.now().hour < 12)
                  Text(
                    'Good Morning',
                    style: InterTextStyles.subtitle.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  )
                else if (DateTime.now().hour < 18)
                  Text(
                    'Good Afternoon',
                    style: InterTextStyles.subtitle.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  )
                else
                  Text(
                    'Good Evening',
                    style: InterTextStyles.subtitle.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ValueListenableBuilder<String>(
                  valueListenable: Userinfo.username,
                  builder: (context, name, _) {
                    return Text(
                      name.isEmpty ? 'Volunteer' : name,
                      style: NunitoTextStyles.title,
                    );
                  },
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: Userinfo.volunteerSessions,
                      builder: (context, value, child) {
                        return SizedBox(
                          width: 150,
                          height: 150,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.backgroundMint,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Userinfo.volunteerSessions.value.toString(),
                                  style: NunitoTextStyles.title.copyWith(
                                    color: AppColors.highlightGreen,
                                  ),
                                ),
                                Text(
                                  'Sessions',
                                  style: NunitoTextStyles.subtitle.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'this term',
                                  style: InterTextStyles.body.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 20),
                    ValueListenableBuilder(
                      valueListenable: Userinfo.studentsAssigned,
                      builder: (context, value, child) {
                        return SizedBox(
                          width: 150,
                          height: 150,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.backgroundMint,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Userinfo.studentsAssigned.value.toString(),
                                  style: NunitoTextStyles.title.copyWith(
                                    color: AppColors.highlightGreen,
                                  ),
                                ),
                                Text(
                                  'Students',
                                  style: NunitoTextStyles.subtitle.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'assigned',
                                  style: InterTextStyles.body.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 20),
                    ValueListenableBuilder<int>(
                      valueListenable: Userinfo.volunteerHours,
                      builder: (context, value, child) {
                        return SizedBox(
                          width: 150,
                          height: 150,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.backgroundMint,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$value',
                                  style: NunitoTextStyles.title.copyWith(
                                    color: AppColors.highlightGreen,
                                  ),
                                ),
                                Text(
                                  'Hours',
                                  style: NunitoTextStyles.subtitle.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'volunteered',
                                  style: InterTextStyles.body.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                const NextSessionsSection(),
                SizedBox(height: 20),
                const AnnouncementsSection(),
                SizedBox(height: 20),
                Text('QUICKLINKS', style: InterTextStyles.subtitle),
                SizedBox(height: 10.0),
                Column(
                  children: [
                    // Row 1: Student Profiles & Resource Library
                    Row(
                      children: [
                        Expanded(
                          child: QuickAccessButton(
                            title: 'Student Profiles',
                            icon: Icons.person_outline_rounded,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentProfilePage(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: QuickAccessButton(
                            title: 'Resource Library',
                            icon: Icons.calendar_today_outlined,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResourceLibraryPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
            
                    // Row 2: My Profile & Tips & Tricks
                    Row(
                      children: [
                        Expanded(
                          child: QuickAccessButton(
                            title: 'My Profile',
                            icon: Icons.near_me_outlined,
                            onPressed: () {
                              selectedIndexNotifier.value =
                                  1; // Switches straight to ProfilePage tab
                            },
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: QuickAccessButton(
                            title: 'Tips & Tricks',
                            icon: Icons.calendar_today_outlined,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResourceLibraryPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: Userinfo.isAdmin,
                      builder: (context, isAdmin, _) {
                        if (!isAdmin) return const SizedBox.shrink();
                        return Column(
                          children: [
                            const SizedBox(height: 12.0),
                            WideQuickAccessButton(
                              title: 'Admin Panel',
                              subtitle:
                                  'Manage students, sessions, and announcements',
                              icon: Icons.verified_user_outlined,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminPanelPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
