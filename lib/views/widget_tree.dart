import 'package:seed_v1/include.dart';

List<Widget> pages = [HomePage(), ProfilePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home'),
        actions: [
        //   IconButton(
        //     onPressed: () {
        //       lightModeNotifier.value = !lightModeNotifier.value;
        //     },
        //     icon: ValueListenableBuilder(
        //       valueListenable: lightModeNotifier,
        //       builder: (context, value, child) {
        //         return Icon(
        //           lightModeNotifier.value ? Icons.dark_mode : Icons.light_mode,
        //         );
        //       },
        //     ),
        //   ),
        ],
      ),
      bottomNavigationBar: NavBar(),
      body: ValueListenableBuilder(
        valueListenable: selectedIndexNotifier,
        builder: (context, value, child) {
          return pages.elementAt(selectedIndexNotifier.value);
        },
      ),
    );
  }
}
