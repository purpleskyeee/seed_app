import 'package:seed_v1/include.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedIndexNotifier,
      builder: (context, selectedIndex, child) {
        return NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: AppColors.backgroundMint,
            // Replaces the bright teal highlight pill
            indicatorColor: AppColors.primaryGreen,
            // Controls label darkness for active vs. inactive tabs
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return InterTextStyles.body.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary, // Darkest text when active
                );
              }
              return InterTextStyles.body.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary, // Muted text when inactive
              );
            }),
            // Controls icon color for active vs. inactive tabs
            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(
                  color: Colors.white, // Crisp white inside primaryGreen pill
                  size: 24,
                );
              }
              return const IconThemeData(
                color: AppColors.highlightGreen, // Dark sage when unselected
                size: 24,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              selectedIndexNotifier.value = index;
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}