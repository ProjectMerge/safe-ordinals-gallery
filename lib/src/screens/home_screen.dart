import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ordinals_pres/src/desktop_screens/dash_desktop_screen.dart';
import 'package:ordinals_pres/src/provider/title_provider.dart';
import 'package:ordinals_pres/src/support/s_p.dart';
import 'package:ordinals_pres/src/widgets/background_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer(builder: (context, watch, _) {
          var tit = watch.watch(titleProvider).greeting;
          return BackgroundWidget(
            splash: false,
            title: tit,
          );
        }),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > 500) {
              return const DesktopDashBoardScreen();
            } else {
              return Container();
            }
          }),
        )
      ],
    );
  }
}
