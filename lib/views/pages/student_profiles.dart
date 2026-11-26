import 'package:seed_v1/include.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Profiles')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Input Box
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search students by name...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF6F736C)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Live Student List View
            Expanded(
              child: ValueListenableBuilder<List<Student>>(
                valueListenable: allStudents,
                builder: (context, students, _) {
                  final query = _searchController.text.trim().toLowerCase();
                  final filteredStudents = query.isEmpty
                      ? students
                      : students
                          .where(
                            (student) =>
                                student.name.toLowerCase().contains(query),
                          )
                          .toList();

                  if (filteredStudents.isEmpty) {
                    return const Center(
                      child: Text(
                        'No students found',
                        style: TextStyle(color: Color(0xFF6F736C)),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: StudentCard(student: student),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}