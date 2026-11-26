import 'package:seed_v1/include.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({super.key, required this.student,});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return MarginBox(
      backgroundColor: AppColors.primaryGreen,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryGreen,
            child: Text(
              student.initials,
              style: const TextStyle(
                color: AppColors.surfaceWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                student.name,
                style: InterTextStyles.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                student.details,
                style: InterTextStyles.body.copyWith(color: Color(0xFF6F736C)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
