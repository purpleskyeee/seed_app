import 'package:seed_v1/include.dart';

// Inter Font Presets
class InterTextStyles {
  static final TextStyle title = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle subtitle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
}

// Nunito Font Presets
class NunitoTextStyles {
  static final TextStyle title = GoogleFonts.nunito(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle subtitle = GoogleFonts.nunito(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle body = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
}

class AppColors {
  static const Color canvasCream = Color(0xFFFAEDCA); //#FAEDCA
  static const Color backgroundMint = Color(0xFFC1DBB3); //#C1DBB3
  static const Color primaryGreen = Color(0xFF7EBC89); //#7EBC89
  static const Color highlightGreen = Color(0xFF3D7A45); //#3D7A45
  static const Color highlightClay = Color(0xFFF2C078); //#F2C078
  static const Color highlightRed = Color(0xFFFE5D26); //#FE5D26
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF191D17);
  static const Color textSecondary = Color(0xFF6F736C);
}

class Userinfo {
  static final ValueNotifier<String> username = ValueNotifier<String>('');
  static final ValueNotifier<String> email = ValueNotifier<String>('');
  static final ValueNotifier<String> school = ValueNotifier<String>('');
  static final ValueNotifier<String> bio = ValueNotifier<String>('');
  static final ValueNotifier<int> volunteerSessions = ValueNotifier<int>(0);
  static final ValueNotifier<int> studentsAssigned = ValueNotifier<int>(0);
  static final ValueNotifier<int> volunteerHours = ValueNotifier<int>(0);
  static final ValueNotifier<bool> isAdmin = ValueNotifier<bool>(false);

  static StreamSubscription? _userSub;
  static String? _listeningEmail;

  static void recalculateAssignedStudents() {
    final currentName = username.value.trim().toLowerCase();
    if (currentName.isEmpty) {
      studentsAssigned.value = 0;
      return;
    }
    studentsAssigned.value = AdminStore.students.value
        .where(
          (s) =>
              (s.assignedVolunteer ?? '').trim().toLowerCase() == currentName,
        )
        .length;
  }

  static void startListening(String userEmail) {
    final normalizedEmail = userEmail.trim().toLowerCase();
    if (_listeningEmail == normalizedEmail && _userSub != null) return;

    _listeningEmail = normalizedEmail;

    // Immediate fallback before Firestore responds
    Future.microtask(() {
      email.value = normalizedEmail;

      final authUser = FirebaseAuth.instance.currentUser;
      if (username.value.isEmpty) {
        final fallbackName = (authUser?.displayName ?? '').trim();
        username.value = fallbackName.isNotEmpty
            ? fallbackName
            : normalizedEmail.split('@').first;
      }
    });

    // Listen directly to volunteers/<normalizedEmail>
    _userSub?.cancel();
    _userSub = FirebaseFirestore.instance
        .collection('volunteers')
        .doc(normalizedEmail)
        .snapshots()
        .listen(
      (doc) {
        if (doc.exists && doc.data() != null) {
          Future.microtask(() {
            _applyUserData(doc.data()!);
            recalculateAssignedStudents();
          });
        } else {
          debugPrint(
            'Userinfo: No Firestore doc found at volunteers/$normalizedEmail',
          );
        }
      },
      onError: (e) => debugPrint('Userinfo Firestore error: $e'),
    );
  }

  static void _applyUserData(Map<String, dynamic> data) {
    final loadedName = (data['name'] ?? data['username'] ?? '').toString().trim();
    if (loadedName.isNotEmpty) {
      username.value = loadedName;
    }
    email.value = (data['email'] ?? _listeningEmail ?? '').toString();
    school.value = (data['school'] ?? '').toString();
    bio.value = (data['bio'] ?? '').toString();
    volunteerSessions.value = (data['volunteerSessions'] as num?)?.toInt() ?? 0;
    studentsAssigned.value = (data['studentsAssigned'] as num?)?.toInt() ?? 0;
    volunteerHours.value = (data['volunteerHours'] as num?)?.toInt() ?? 0;
    isAdmin.value = data['isAdmin'] == true;
  }

  static Future<void> stopListening() async {
    await _userSub?.cancel();
    _userSub = null;
    _listeningEmail = null;
    Future.microtask(() {
      username.value = '';
      email.value = '';
      school.value = '';
      bio.value = '';
      volunteerSessions.value = 0;
      studentsAssigned.value = 0;
      volunteerHours.value = 0;
      isAdmin.value = false;
    });
  }
}

class Student {
  final String name;
  final String details;
  final String initials;

  Student({required this.name, required this.details, required this.initials});
}

final ValueNotifier<List<Student>> allStudents = ValueNotifier<List<Student>>(
  [],
);

class ResourceItem {
  final String title;
  final String description;
  final IconData icon;
  final String tag;

  const ResourceItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.tag,
  });
}

const List<ResourceItem> resourceList = [
  ResourceItem(
    title: 'Icebreaker Games',
    description: '15 quick activities to open any session and build trust fast with new learners.',
    icon: Icons.grid_view_rounded,
    tag: 'Engagement',
  ),
  ResourceItem(
    title: 'Phonics Cheat Sheet',
    description: 'One-page guide to consonant clusters, digraphs, and long vowel sounds.',
    icon: Icons.menu_book_rounded,
    tag: 'Literacy',
  ),
  ResourceItem(
    title: 'Dealing with Shyness',
    description: 'Strategies for gentle, low-pressure communication with anxious learners.',
    icon: Icons.favorite_border_rounded,
    tag: 'Wellbeing',
  ),
  ResourceItem(
    title: 'Vocabulary Sheets',
    description: 'Themed word lists: family, food, school, body, transport, and weather.',
    icon: Icons.description_outlined,
    tag: 'Literacy',
  ),
  ResourceItem(
    title: 'Storytelling Starters',
    description: 'Picture prompts and sentence frames for creative oral storytelling practice.',
    icon: Icons.star_border_rounded,
    tag: 'Engagement',
  ),
  ResourceItem(
    title: 'Progress Rubric',
    description:
        'Simple 4-point rubric aligned to CEFR Pre-A1 through A2 milestones.',
    icon: Icons.bar_chart_rounded,
    tag: 'Assessment',
  ),
];