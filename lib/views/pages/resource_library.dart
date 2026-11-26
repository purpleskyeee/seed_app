import 'package:seed_v1/include.dart';

class ResourceLibraryPage extends StatelessWidget {
  const ResourceLibraryPage({super.key});

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
          // Increased horizontal padding on the sides
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resource Library',
                style: InterTextStyles.title.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Tips, tools, and teaching ideas for your sessions.',
                style: InterTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20.0),

              // Dynamic 2-column layout sized to fit card content
              for (int i = 0; i < resourceList.length; i += 2) ...[
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ResourceCard(
                          item: resourceList[i],
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 14.0),
                      Expanded(
                        child: i + 1 < resourceList.length
                            ? ResourceCard(
                                item: resourceList[i + 1],
                                onTap: () {},
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                if (i + 2 < resourceList.length) const SizedBox(height: 14.0),
              ],
            ],
          ),
        ),
      ),
    );
  }
}