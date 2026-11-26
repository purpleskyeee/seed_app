import 'package:seed_v1/include.dart';

class TextInput extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;

  const TextInput({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: NunitoTextStyles.subtitle),
        const SizedBox(height: 8.0),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizedBox(
            width: 500.0,
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: InterTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}