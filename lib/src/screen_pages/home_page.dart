
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ordinals_pres/src/support/app_sizes.dart';
import 'package:ordinals_pres/src/support/breakpoints.dart';
import 'package:ordinals_pres/src/widgets/account_widget.dart';
import 'package:ordinals_pres/src/widgets/art_tile.dart';
import 'package:ordinals_pres/src/widgets/concave_clip_container.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () {
    //   ref.read(titleProvider).greeting = "Dashboard";
    // });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, cons) {
        final size = cons.biggest;
        final isDesktop = size.width > Breakpoint.tablet;
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: isDesktop ? _buildDesktop(size) : _buildMobile(size),
        );
      },
    );
  }

  Widget _buildDesktop(Size size) {
    return Column(
      children: [
        gapH32,
        Row(
          children: [
            gapW32,
            Container(
                height: 50,
                width: size.width * 0.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    gapW12,
                    Icon(
                      Icons.search,
                      size: 24,
                    ),
                    gapW32,
                    Text(
                      "Search",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                )),
            const Expanded(child: SizedBox()),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black.withOpacity(0.1)),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications,
                color: Colors.white70,
                size: 24,
              ),
            ),
            //profile pic
           gapW32,
            gapW32,
          ],
        ),
        gapH64,
        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              width: size.width * 0.95,
              child: Stack(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 8.0, right: 12.0),
                      height: size.height * 0.28,
                      width: size.width * 0.622,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Banner",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    gapH8,
                    GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        if (index == 2) {
                          return const SizedBox.shrink();
                        }
                        return const ArtTile();
                      },
                      itemCount: 8,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ],
                ),
                Positioned(
                    right: 10,
                    top: 0,
                    child: Container(
                      height: size.height * .765,
                      width: size.width * 0.305,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(child: Text("Side Banner")),
                    ))
              ]),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMobile(Size size) {
    return Container();
  }
}
