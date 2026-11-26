import 'package:seed_v1/include.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  int _selectedTab = 0; // 0: Announcements, 1: Students, 2: Sessions

  // --- Announcements Form State ---
  bool _showAnnouncementForm = false;
  final TextEditingController _annTitleController = TextEditingController();
  final TextEditingController _annBodyController = TextEditingController();
  bool _pinToDashboard = false;

  // --- Students Form State ---
  bool _showStudentForm = false;
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _studentAgeController = TextEditingController();
  final TextEditingController _studentGradeController = TextEditingController();
  String _selectedLevel = 'Beginner';
  String? _selectedVolunteer;

  // --- Sessions Inline Form State ---
  String? _activeSlotDayForm; // Which day has "+ Add slot" open
  String? _editingSlotId; // Non-null when editing an existing slot
  final TextEditingController _slotTimeController = TextEditingController();
  final TextEditingController _slotRoomController = TextEditingController();
  final TextEditingController _slotDateController = TextEditingController();
  String? _slotStudent;
  String? _slotVolunteer;

  @override
  void dispose() {
    _annTitleController.dispose();
    _annBodyController.dispose();
    _studentNameController.dispose();
    _studentAgeController.dispose();
    _studentGradeController.dispose();
    _slotTimeController.dispose();
    _slotRoomController.dispose();
    _slotDateController.dispose();
    super.dispose();
  }

  String _formattedToday() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final now = DateTime.now();
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Page Header with Shield Badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Icon(
                      Icons.verified_user_outlined,
                      color: Colors.white,
                      size: 22.0,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    'Admin Panel',
                    style: InterTextStyles.title.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18.0),

              // 2. Segmented Tab Bar
              _buildSegmentedTabBar(),
              const SizedBox(height: 20.0),

              // 3. Active Tab Content
              if (_selectedTab == 0) _buildAnnouncementsTab(),
              if (_selectedTab == 1) _buildStudentsTab(),
              if (_selectedTab == 2) _buildSessionsTab(),
              if (_selectedTab==3) _buildManageAdminsSection(),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SEGMENTED TAB BAR
  // ===========================================================================
  Widget _buildSegmentedTabBar() {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundMint,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          _buildSegmentItem(
            index: 0,
            label: 'Announcements',
            icon: Icons.near_me_outlined,
          ),
          _buildSegmentItem(
            index: 1,
            label: 'Students',
            icon: Icons.people_outline,
          ),
          _buildSegmentItem(
            index: 2,
            label: 'Sessions',
            icon: Icons.calendar_today_outlined,
          ),
          _buildSegmentItem(
            index: 3,
            label: 'Admins',
            icon: Icons.admin_panel_settings_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentItem({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.0,
                color: isSelected ? Colors.white : AppColors.highlightGreen,
              ),
              const SizedBox(width: 5.0),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: InterTextStyles.body.copyWith(
                    fontSize: 13.0,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.highlightGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // TAB 1: ANNOUNCEMENTS
  // ===========================================================================
  Widget _buildAnnouncementsTab() {
    return Column(
      children: [
        // Button OR Outlined New Announcement Card
        if (!_showAnnouncementForm)
          _buildPrimaryActionButton(
            label: 'Post Announcement',
            onPressed: () {
              setState(() {
                _annTitleController.clear();
                _annBodyController.clear();
                _pinToDashboard = false;
                _showAnnouncementForm = true;
              });
            },
          )
        else
          _buildNewAnnouncementCard(),

        const SizedBox(height: 16.0),

        // Live List of Announcements
        ValueListenableBuilder<List<AnnouncementItem>>(
          valueListenable: AdminStore.announcements,
          builder: (context, items, _) {
            if (items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Center(
                  child: Text(
                    'No announcements yet.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              );
            }
            return Column(
              children: items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: _buildAnnouncementCard(item),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNewAnnouncementCard() {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.primaryGreen, width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NEW ANNOUNCEMENT',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6F736C),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12.0),
          TextField(
            controller: _annTitleController,
            decoration: _softInputDecoration('Title'),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _annBodyController,
            minLines: 3,
            maxLines: 5,
            decoration: _softInputDecoration('Message body...'),
          ),
          const SizedBox(height: 14.0),
          Row(
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: Checkbox(
                  value: _pinToDashboard,
                  activeColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  onChanged: (val) {
                    setState(() => _pinToDashboard = val ?? false);
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              GestureDetector(
                onTap: () => setState(() => _pinToDashboard = !_pinToDashboard),
                child: Text(
                  'Pin to dashboard',
                  style: InterTextStyles.body.copyWith(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => setState(() => _showAnnouncementForm = false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 6.0),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 10.0,
                  ),
                ),
                onPressed: () {
                  final title = _annTitleController.text.trim();
                  final body = _annBodyController.text.trim();
                  if (title.isEmpty || body.isEmpty) return;

                  AdminStore.addAnnouncement(
                    AnnouncementItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: title,
                      body: body,
                      date: _formattedToday(),
                      isPinned: _pinToDashboard,
                    ),
                  );
                  setState(() => _showAnnouncementForm = false);
                },
                child: const Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(AnnouncementItem item) {
    final cardContent = Container(
      margin: item.isPinned
          ? const EdgeInsets.only(left: 5.0)
          : EdgeInsets.zero,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.isPinned) ...[
                const Padding(
                  padding: EdgeInsets.only(top: 2.0, right: 6.0),
                  child: Icon(
                    Icons.push_pin_outlined,
                    size: 16.0,
                    color: Color(0xFF9C6B19),
                  ),
                ),
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
              const SizedBox(width: 8.0),
              // Pin Toggle Icon
              InkWell(
                onTap: () => AdminStore.togglePinAnnouncement(item.id),
                borderRadius: BorderRadius.circular(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.push_pin_outlined,
                    size: 17.0,
                    color: item.isPinned
                        ? const Color(0xFF9C6B19)
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 4.0),
              // Delete Trash Bin Icon
              InkWell(
                onTap: () => AdminStore.deleteAnnouncement(item.id),
                borderRadius: BorderRadius.circular(8.0),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.delete_outline,
                    size: 18.0,
                    color: AppColors.highlightRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            item.body,
            style: InterTextStyles.body.copyWith(
              fontSize: 13.5,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            item.date,
            style: InterTextStyles.body.copyWith(
              fontSize: 12.0,
              color: const Color(0xFF8C857B),
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

  // ===========================================================================
  // TAB 2: STUDENTS
  // ===========================================================================
  Widget _buildStudentsTab() {
    return Column(
      children: [
        if (!_showStudentForm)
          _buildPrimaryActionButton(
            label: 'Add Student',
            onPressed: () {
              setState(() {
                _studentNameController.clear();
                _studentAgeController.clear();
                _studentGradeController.clear();
                _selectedLevel = 'Beginner';
                _selectedVolunteer = null;
                _showStudentForm = true;
              });
            },
          )
        else
          _buildNewStudentCard(),

        const SizedBox(height: 16.0),

        ValueListenableBuilder<List<AdminStudent>>(
          valueListenable: AdminStore.students,
          builder: (context, studentList, _) {
            if (studentList.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Center(
                  child: Text(
                    'No students registered yet.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              );
            }
            return Column(
              children: studentList
                  .map(
                    (student) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _buildAdminStudentCard(student),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNewStudentCard() {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.primaryGreen, width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NEW STUDENT',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6F736C),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12.0),
          _buildFieldLabel('Full Name *'),
          TextField(
            controller: _studentNameController,
            decoration: _softInputDecoration('Student name'),
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Age'),
                    TextField(
                      controller: _studentAgeController,
                      keyboardType: TextInputType.number,
                      decoration: _softInputDecoration('8'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Grade'),
                    TextField(
                      controller: _studentGradeController,
                      decoration: _softInputDecoration('Grade 2'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          _buildFieldLabel('English Level'),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: AdminStore.englishLevels.map((level) {
              final bool isSelected = _selectedLevel == level;
              return GestureDetector(
                onTap: () => setState(() => _selectedLevel = level),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AdminStore.levelBgColor(level)
                        : const Color(0xFFF2F2F0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    level,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AdminStore.levelTextColor(level)
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12.0),
          _buildFieldLabel('Volunteer'),
          ValueListenableBuilder<List<String>>(
            valueListenable: AdminStore.volunteers,
            builder: (context, volunteerList, _) {
              final options = {
                ...volunteerList,
                if (_selectedVolunteer != null &&
                    _selectedVolunteer!.trim().isNotEmpty)
                  _selectedVolunteer!.trim(),
              }.toList();

              final validVolunteerValue = options.contains(_selectedVolunteer)
                  ? _selectedVolunteer
                  : null;

              return DropdownButtonFormField<String?>(
                value: validVolunteerValue,
                isExpanded: true,
                decoration: _softInputDecoration('— Unassigned —'),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('— Unassigned —'),
                  ),
                  ...options.map(
                    (v) => DropdownMenuItem<String?>(
                      value: v,
                      child: Text(v, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
                onChanged: (val) => setState(() => _selectedVolunteer = val),
              );
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => setState(() => _showStudentForm = false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 11.0,
                  ),
                ),
                onPressed: () {
                  final name = _studentNameController.text.trim();
                  if (name.isEmpty) return;

                  final age =
                      int.tryParse(_studentAgeController.text.trim()) ?? 8;
                  final grade = _studentGradeController.text.trim().isEmpty
                      ? 'Grade 2'
                      : _studentGradeController.text.trim();

                  AdminStore.addStudent(
                    AdminStudent(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      age: age,
                      grade: grade,
                      level: _selectedLevel,
                      assignedVolunteer: _selectedVolunteer,
                    ),
                  );
                  setState(() {
                    _selectedVolunteer = null;
                    _showStudentForm = false;
                  });
                },
                child: const Text(
                  'Add Student',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminStudentCard(AdminStudent student) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primaryGreen,
            child: Text(
              student.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: InterTextStyles.subtitle.copyWith(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  '${student.grade} · Age ${student.age}',
                  style: InterTextStyles.body.copyWith(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6.0),
                Row(
                  children: [
                    Text(
                      student.assignedVolunteer ?? 'Unassigned',
                      style: InterTextStyles.body.copyWith(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    InkWell(
                      onTap: () => _showReassignVolunteerDialog(student),
                      borderRadius: BorderRadius.circular(6.0),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 14.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Level Tag Pill
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11.0,
              vertical: 5.0,
            ),
            decoration: BoxDecoration(
              color: AdminStore.levelBgColor(student.level),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              student.level,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: AdminStore.levelTextColor(student.level),
              ),
            ),
          ),
          const SizedBox(width: 10.0),

          // Trash Bin Delete Icon
          InkWell(
            onTap: () => AdminStore.deleteStudent(student.id),
            borderRadius: BorderRadius.circular(8.0),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.delete_outline,
                size: 19.0,
                color: AppColors.highlightRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReassignVolunteerDialog(AdminStudent student) {
    String? tempVolunteer = student.assignedVolunteer;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Assign Volunteer (${student.name})',
            style: InterTextStyles.subtitle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: DropdownButtonFormField<String?>(
            value: tempVolunteer,
            decoration: _softInputDecoration('— Unassigned —'),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('— Unassigned —'),
              ),
              ...AdminStore.volunteers.value.map(
                (v) => DropdownMenuItem<String?>(value: v, child: Text(v)),
              ),
            ],
            onChanged: (val) => tempVolunteer = val,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
              onPressed: () {
                AdminStore.updateStudent(
                  student.copyWith(
                    assignedVolunteer: tempVolunteer,
                    clearVolunteer: tempVolunteer == null,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // TAB 3: SESSIONS
  // ===========================================================================
  Widget _buildSessionsTab() {
    return ValueListenableBuilder<List<SessionSlot>>(
      valueListenable: AdminStore.sessions,
      builder: (context, allSlots, _) {
        return Column(
          children: AdminStore.sessionDays.map((day) {
            final daySlots = allSlots.where((s) => s.day == day).toList();
            final bool isFormOpenForDay = _activeSlotDayForm == day;

            return Padding(
              padding: const EdgeInsets.only(bottom: 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day Header + "+ Add slot" Pill Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        day,
                        style: InterTextStyles.subtitle.copyWith(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isFormOpenForDay && _editingSlotId == null) {
                              _activeSlotDayForm = null;
                            } else {
                              _editingSlotId = null;
                              _activeSlotDayForm = day;
                              _slotTimeController.clear();
                              _slotRoomController.clear();
                              _slotDateController.clear();
                              _slotStudent = null;
                              _slotVolunteer = null;
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 7.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundMint,
                            borderRadius: BorderRadius.circular(20.0),
                            border: isFormOpenForDay
                                ? Border.all(
                                    color: AppColors.textPrimary,
                                    width: 1.5,
                                  )
                                : null,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                size: 16.0,
                                color: AppColors.highlightGreen,
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                'Add slot',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.highlightGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),

                  // Inline Add / Edit Slot Card
                  if (isFormOpenForDay) ...[
                    _buildSlotEditorCard(day),
                    const SizedBox(height: 12.0),
                  ],

                  // Slot Cards for This Day
                  ...daySlots.map(
                    (slot) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: _buildSessionSlotCard(slot),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSlotEditorCard(String day) {
    return ValueListenableBuilder<List<AdminStudent>>(
      valueListenable: AdminStore.students,
      builder: (context, studentList, _) {
        final studentNames = studentList.map((s) => s.name).toList();
        final validStudentValue = studentNames.contains(_slotStudent)
            ? _slotStudent
            : null;

        return Container(
          padding: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: AppColors.primaryGreen, width: 2.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Time *'),
                        TextField(
                          controller: _slotTimeController,
                          decoration: _softInputDecoration('e.g. 4:00 PM'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Room'),
                        TextField(
                          controller: _slotRoomController,
                          decoration: _softInputDecoration('Room 3A'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Next date'),
                        TextField(
                          controller: _slotDateController,
                          decoration: _softInputDecoration('Oct 6, 2026'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Student'),
                        DropdownButtonFormField<String?>(
                          value: validStudentValue,
                          isExpanded: true,
                          decoration: _softInputDecoration('— TBD —'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('— TBD —'),
                            ),
                            ...studentNames.map(
                              (name) => DropdownMenuItem<String?>(
                                value: name,
                                child: Text(
                                  name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (val) =>
                              setState(() => _slotStudent = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              _buildFieldLabel('Volunteer'),
              ValueListenableBuilder<List<String>>(
                valueListenable: AdminStore.volunteers,
                builder: (context, volunteerList, _) {
                  final options = {
                    ...volunteerList,
                    if (_slotVolunteer != null &&
                        _slotVolunteer!.trim().isNotEmpty)
                      _slotVolunteer!.trim(),
                  }.toList();

                  final validVolunteerValue = options.contains(_slotVolunteer)
                      ? _slotVolunteer
                      : null;

                  return DropdownButtonFormField<String?>(
                    value: validVolunteerValue,
                    isExpanded: true,
                    decoration: _softInputDecoration('— Unassigned —'),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('— Unassigned —'),
                      ),
                      ...options.map(
                        (v) => DropdownMenuItem<String?>(
                          value: v,
                          child: Text(v, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                    onChanged: (val) => setState(() => _slotVolunteer = val),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _activeSlotDayForm = null;
                        _editingSlotId = null;
                      });
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 11.0,
                      ),
                    ),
                    onPressed: () {
                      final time = _slotTimeController.text.trim();
                      if (time.isEmpty) return;

                      final room = _slotRoomController.text.trim().isEmpty
                          ? 'Room 3A'
                          : _slotRoomController.text.trim();
                      final date = _slotDateController.text.trim().isEmpty
                          ? 'Oct 6, 2026'
                          : _slotDateController.text.trim();

                      if (_editingSlotId != null) {
                        AdminStore.updateSessionSlot(
                          SessionSlot(
                            id: _editingSlotId!,
                            day: day,
                            time: time,
                            room: room,
                            nextDate: date,
                            studentName: _slotStudent,
                            volunteerName: _slotVolunteer,
                          ),
                        );
                      } else {
                        AdminStore.addSessionSlot(
                          SessionSlot(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            day: day,
                            time: time,
                            room: room,
                            nextDate: date,
                            studentName: _slotStudent,
                            volunteerName: _slotVolunteer,
                          ),
                        );
                      }

                      setState(() {
                        setState(() {
                          _activeSlotDayForm = null;
                          _editingSlotId = null;
                          _slotVolunteer = null;
                          _slotStudent = null;
                        });
                      });
                    },
                    child: const Text(
                      'Save Slot',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSessionSlotCard(SessionSlot slot) {
    final bool isStudentTbd =
        slot.studentName == null || slot.studentName!.isEmpty;
    final bool isVolunteerTbd =
        slot.volunteerName == null || slot.volunteerName!.isEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time · Room · Date
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: slot.time,
                        style: InterTextStyles.subtitle.copyWith(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: '  ·  ${slot.room}  ·  ${slot.nextDate}',
                        style: InterTextStyles.body.copyWith(
                          fontSize: 13.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6.0),

                // Student · Volunteer (highlighted in amber when TBD)
                Row(
                  children: [
                    Text(
                      isStudentTbd ? 'Student TBD' : slot.studentName!,
                      style: InterTextStyles.body.copyWith(
                        fontSize: 13.0,
                        fontWeight: isStudentTbd
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isStudentTbd
                            ? const Color(0xFFE68A00)
                            : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '  ·  ',
                      style: InterTextStyles.body.copyWith(
                        fontSize: 13.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      isVolunteerTbd ? 'Volunteer TBD' : slot.volunteerName!,
                      style: InterTextStyles.body.copyWith(
                        fontSize: 13.0,
                        fontWeight: isVolunteerTbd
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isVolunteerTbd
                            ? const Color(0xFFE68A00)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Edit Pencil Icon
          InkWell(
            onTap: () {
              setState(() {
                _activeSlotDayForm = slot.day;
                _editingSlotId = slot.id;
                _slotTimeController.text = slot.time;
                _slotRoomController.text = slot.room;
                _slotDateController.text = slot.nextDate;
                _slotStudent = slot.studentName;
                _slotVolunteer = slot.volunteerName;
              });
            },
            borderRadius: BorderRadius.circular(8.0),
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(
                Icons.edit_outlined,
                size: 18.0,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 4.0),

          // Delete Trash Bin Icon
          InkWell(
            onTap: () => AdminStore.deleteSessionSlot(slot.id),
            borderRadius: BorderRadius.circular(8.0),
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(
                Icons.delete_outline,
                size: 18.5,
                color: AppColors.highlightRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SHARED UI HELPERS
  // ===========================================================================
  Widget _buildPrimaryActionButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.highlightRed,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        onPressed: onPressed,
        icon: const Icon(Icons.add, color: Colors.white, size: 20.0),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: InterTextStyles.body.copyWith(
          fontSize: 12.5,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  InputDecoration _softInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF8C857B), fontSize: 14.0),
      filled: true,
      fillColor: const Color(0xFFF5F5F4),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14.0,
        vertical: 12.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
    );
  }
}

Widget _buildManageAdminsSection() {
  return ValueListenableBuilder<List<VolunteerRecord>>(
    valueListenable: AdminStore.volunteerRecords,
    builder: (context, records, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VOLUNTEER ADMINS',
            style: InterTextStyles.body.copyWith(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: const Color(0xFF7B756C),
            ),
          ),
          const SizedBox(height: 12.0),
          ...records.map((volunteer) {
            final isSelf = volunteer.email == Userinfo.email.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isSelf ? '${volunteer.name} (You)' : volunteer.name,
                          style: InterTextStyles.subtitle.copyWith(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          volunteer.email,
                          style: InterTextStyles.body.copyWith(
                            fontSize: 12.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: volunteer.isAdmin,
                    activeColor: AppColors.primaryGreen,
                    onChanged: isSelf
                        ? null
                        : (val) =>
                            AdminStore.setVolunteerAdmin(volunteer.email, val),
                  ),
                ],
              ),
            );
          }),
        ],
      );
    },
  );
}