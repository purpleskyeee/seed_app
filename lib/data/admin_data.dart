import 'package:seed_v1/include.dart';

class AnnouncementItem {
  final String id;
  final String title;
  final String body;
  final String date;
  final bool isPinned;

  const AnnouncementItem({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.isPinned = false,
  });

  AnnouncementItem copyWith({
    String? title,
    String? body,
    String? date,
    bool? isPinned,
  }) {
    return AnnouncementItem(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      date: date ?? this.date,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}

class AdminStudent {
  final String id;
  final String name;
  final int age;
  final String grade;
  final String level;
  final String? assignedVolunteer;

  const AdminStudent({
    required this.id,
    required this.name,
    required this.age,
    required this.grade,
    required this.level,
    this.assignedVolunteer,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  AdminStudent copyWith({
    String? name,
    int? age,
    String? grade,
    String? level,
    String? assignedVolunteer,
    bool clearVolunteer = false,
  }) {
    return AdminStudent(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      grade: grade ?? this.grade,
      level: level ?? this.level,
      assignedVolunteer: clearVolunteer
          ? null
          : (assignedVolunteer ?? this.assignedVolunteer),
    );
  }
}

class SessionSlot {
  final String id;
  final String day;
  final String time;
  final String room;
  final String nextDate;
  final String? studentName;
  final String? volunteerName;

  const SessionSlot({
    required this.id,
    required this.day,
    required this.time,
    required this.room,
    required this.nextDate,
    this.studentName,
    this.volunteerName,
  });

  SessionSlot copyWith({
    String? day,
    String? time,
    String? room,
    String? nextDate,
    String? studentName,
    String? volunteerName,
    bool clearStudent = false,
    bool clearVolunteer = false,
  }) {
    return SessionSlot(
      id: id,
      day: day ?? this.day,
      time: time ?? this.time,
      room: room ?? this.room,
      nextDate: nextDate ?? this.nextDate,
      studentName: clearStudent ? null : (studentName ?? this.studentName),
      volunteerName: clearVolunteer
          ? null
          : (volunteerName ?? this.volunteerName),
    );
  }
}

class AdminStore {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static final ValueNotifier<List<String>> volunteers =
      ValueNotifier<List<String>>([]);

  static StreamSubscription? _volunteerSub;

  static const List<String> englishLevels = [
    'Starter',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  static const List<String> sessionDays = ['Monday', 'Wednesday', 'Friday'];

  static final ValueNotifier<List<AnnouncementItem>> announcements =
      ValueNotifier<List<AnnouncementItem>>([]);

  static final ValueNotifier<List<AdminStudent>> students =
      ValueNotifier<List<AdminStudent>>([]);

  static final ValueNotifier<List<SessionSlot>> sessions =
      ValueNotifier<List<SessionSlot>>([]);

  static final ValueNotifier<List<VolunteerRecord>> volunteerRecords =
      ValueNotifier<List<VolunteerRecord>>([]);

  static StreamSubscription? _annSub;
  static StreamSubscription? _studentSub;
  static StreamSubscription? _sessionSub;

  static bool _isListening = false;

  static void startListening() {
    if (_isListening) return;
    _isListening = true;

    // 1. Live Announcements
    _annSub?.cancel();
    _annSub = _db.collection('announcements').snapshots().listen((snapshot) {
      final docs = snapshot.docs.toList();
      docs.sort((a, b) {
        final aPinned = (a.data()['isPinned'] ?? false) as bool;
        final bPinned = (b.data()['isPinned'] ?? false) as bool;
        if (aPinned != bPinned) return bPinned ? 1 : -1;

        final aTime = a.data()['createdAt'] as Timestamp?;
        final bTime = b.data()['createdAt'] as Timestamp?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return -1;
        if (bTime == null) return 1;
        return bTime.compareTo(aTime);
      });

      final items = docs.map((doc) {
        final data = doc.data();
        return AnnouncementItem(
          id: doc.id,
          title: data['title'] ?? '',
          body: data['body'] ?? '',
          date: data['date'] ?? '',
          isPinned: data['isPinned'] ?? false,
        );
      }).toList();

      Future.microtask(() {
        announcements.value = items;
      });
    });

    // 2. Live Students
    _studentSub?.cancel();
    _studentSub = _db.collection('students').orderBy('name').snapshots().listen(
      (snapshot) {
        final list = snapshot.docs.map((doc) {
          final data = doc.data();
          return AdminStudent(
            id: doc.id,
            name: data['name'] ?? '',
            age: data['age'] ?? 8,
            grade: data['grade'] ?? 'Grade 1',
            level: data['level'] ?? 'Starter',
            assignedVolunteer: data['assignedVolunteer'],
          );
        }).toList();

        final mappedStudents = list
            .map(
              (s) => Student(
                name: s.name,
                details: '${s.grade} · Age ${s.age} · ${s.level}',
                initials: s.initials,
              ),
            )
            .toList();

        Future.microtask(() {
          students.value = list;
          allStudents.value = mappedStudents;
          Userinfo.recalculateAssignedStudents();
        });
      },
    );

    // 3. Live Sessions
    _sessionSub?.cancel();
    _sessionSub = _db.collection('sessions').snapshots().listen((snapshot) {
      final list = snapshot.docs.map((doc) {
        final data = doc.data();
        return SessionSlot(
          id: doc.id,
          day: data['day'] ?? 'Monday',
          time: data['time'] ?? '',
          room: data['room'] ?? '',
          nextDate: data['nextDate'] ?? '',
          studentName: data['studentName'],
          volunteerName: data['volunteerName'],
        );
      }).toList();

      Future.microtask(() {
        sessions.value = list;
      });
    });

    // 4. Live Registered Volunteers & Admin Flags
    _volunteerSub?.cancel();
    _volunteerSub = _db.collection('volunteers').snapshots().listen((snapshot) {
      final records =
          snapshot.docs.map((doc) {
            final data = doc.data();
            final rawName = (data['name'] ?? '').toString().trim();
            return VolunteerRecord(
              email: doc.id,
              name: rawName.isNotEmpty ? rawName : doc.id.split('@').first,
              isAdmin: (data['isAdmin'] ?? false) as bool,
            );
          }).toList()..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );

      final names = records.map((r) => r.name).toSet().toList()..sort();

      Future.microtask(() {
        volunteerRecords.value = records;
        volunteers.value = names;
      });
    });
  }

  // --- Announcement Cloud CRUD ---
  static Future<void> addAnnouncement(AnnouncementItem item) async {
    await _db.collection('announcements').add({
      'title': item.title,
      'body': item.body,
      'date': item.date,
      'isPinned': item.isPinned,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> togglePinAnnouncement(String id) async {
    final current = announcements.value.firstWhere((a) => a.id == id);
    await _db.collection('announcements').doc(id).update({
      'isPinned': !current.isPinned,
    });
  }

  static Future<void> deleteAnnouncement(String id) async {
    await _db.collection('announcements').doc(id).delete();
  }

  // --- Student Cloud CRUD ---
  static Future<void> addStudent(AdminStudent student) async {
    await _db.collection('students').add({
      'name': student.name,
      'age': student.age,
      'grade': student.grade,
      'level': student.level,
      'assignedVolunteer': student.assignedVolunteer,
    });
  }

  static Future<void> updateStudent(AdminStudent student) async {
    await _db.collection('students').doc(student.id).update({
      'name': student.name,
      'age': student.age,
      'grade': student.grade,
      'level': student.level,
      'assignedVolunteer': student.assignedVolunteer,
    });
  }

  static Future<void> deleteStudent(String id) async {
    // Look up the student's name before removing the document
    final matchingStudent = students.value.where((s) => s.id == id).firstOrNull;
    String? studentName = matchingStudent?.name;

    if (studentName == null) {
      final doc = await _db.collection('students').doc(id).get();
      studentName = doc.data()?['name']?.toString();
    }

    await _db.collection('students').doc(id).delete();

    // Delete all sessions linked to this student
    if (studentName != null && studentName.trim().isNotEmpty) {
      final normalizedName = studentName.trim().toLowerCase();
      final orphanedSessions = sessions.value.where(
        (slot) =>
            (slot.studentName ?? '').trim().toLowerCase() == normalizedName,
      );

      for (final slot in orphanedSessions) {
        await _db.collection('sessions').doc(slot.id).delete();
      }
    }
  }

  static Future<void> setVolunteerAdmin(String email, bool isAdmin) async {
    if (!Userinfo.isAdmin.value) return;
    await _db.collection('volunteers').doc(email.trim().toLowerCase()).update({
      'isAdmin': isAdmin,
    });
  }

  // --- Session Cloud CRUD ---
  static Future<void> addSessionSlot(SessionSlot slot) async {
    await _db.collection('sessions').add({
      'day': slot.day,
      'time': slot.time,
      'room': slot.room,
      'nextDate': slot.nextDate,
      'studentName': slot.studentName,
      'volunteerName': slot.volunteerName,
    });
  }

  static Future<void> updateSessionSlot(SessionSlot slot) async {
    await _db.collection('sessions').doc(slot.id).update({
      'day': slot.day,
      'time': slot.time,
      'room': slot.room,
      'nextDate': slot.nextDate,
      'studentName': slot.studentName,
      'volunteerName': slot.volunteerName,
    });
  }

  static Future<void> deleteSessionSlot(String id) async {
    await _db.collection('sessions').doc(id).delete();
  }

  // --- Level Pill Styling Helpers ---
  static Color levelBgColor(String level) {
    switch (level) {
      case 'Beginner':
        return AppColors.highlightClay;
      case 'Intermediate':
        return AppColors.primaryGreen;
      case 'Advanced':
        return AppColors.highlightRed;
      case 'Starter':
      default:
        return AppColors.backgroundMint;
    }
  }

  static Color levelTextColor(String level) {
    switch (level) {
      case 'Beginner':
        return const Color(0xFF5C3A00);
      case 'Intermediate':
      case 'Advanced':
        return Colors.white;
      case 'Starter':
      default:
        return AppColors.highlightGreen;
    }
  }

  static Future<void> stopListening() async {
    await _annSub?.cancel();
    _annSub = null;
    await _studentSub?.cancel();
    _studentSub = null;
    await _sessionSub?.cancel();
    _sessionSub = null;
    await _volunteerSub?.cancel();
    _volunteerSub = null;
    _isListening = false;
  }
}

class VolunteerRecord {
  final String email;
  final String name;
  final bool isAdmin;

  const VolunteerRecord({
    required this.email,
    required this.name,
    required this.isAdmin,
  });
}