import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ordinals_pres/src/provider/gallery_provider.dart';
import 'package:ordinals_pres/src/screen_pages/gallery_page.dart';
import 'package:ordinals_pres/src/screen_pages/home_page.dart';
import 'package:ordinals_pres/src/support/app_sizes.dart';
import 'package:ordinals_pres/src/support/auth_repo.dart';
import 'package:ordinals_pres/src/widgets/menu_item.dart';
import 'package:ordinals_pres/src/widgets/responsible_center.dart';
import 'package:ordinals_pres/globals.dart' as globals;
import 'package:http/http.dart' as http;

// lib/src/desktop_screens/reference_screen.dart
class DesktopDashBoardScreen extends ConsumerStatefulWidget {
  const DesktopDashBoardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DesktopDashBoardScreen> createState() => _DesktopDashScreenState();
}

class _DesktopDashScreenState extends ConsumerState<DesktopDashBoardScreen> with SingleTickerProviderStateMixin {
  var page = 0;
  var _qrcancelled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveCenter(
        maxContentWidth: 2160,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          children: [
            Container(
                width: double.infinity,
                height: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: 90,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              gapH12,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFF19243D),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: SvgPicture.asset(
                                        "assets/images/rocketbot_logo.svg",
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              gapH128,
                              MenuItem(
                                page: 0,
                                onTap: () {
                                  ref.invalidate(galleryProvider);
                                  setState(() {
                                    page = 0;
                                  });
                                },
                                pageCurrent: page,
                                picture: "assets/images/gallery.png",
                              ),
                              gapH48,
                              MenuItem(
                                page: 1,
                                onTap: () {
                                  setState(() {
                                    page = 1;
                                  });
                                },
                                pageCurrent: page,
                                picture: "assets/images/home.png",
                              ),
                              gapH48,
                              ref.watch(authStateChangesProvider).when(
                                  data: (data) {
                                    if (data?.email != null) {
                                      return MenuItem(
                                        page: 2,
                                        onTap: () {
                                          setState(() {
                                            page = 2;
                                          });
                                        },
                                        pageCurrent: page,
                                        picture: "assets/images/gallery.png",
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                  error: (e, st) => Container(),
                                  loading: () => Container()),
                            ],
                          )),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              reverseDuration: const Duration(milliseconds: 100),
                              switchInCurve: Curves.decelerate,
                              switchOutCurve: Curves.bounceIn,
                              child: returnPage(page),
                            ),
                          ),
                        ),
                      ),
                    ])),
          ],
        ));
  }
}



Widget returnPage(int page) {
  switch (page) {
    case 0:
      return const GalleryPage(
        key: ValueKey("GalleryPage"),
      );
    case 1:
      return const HomePage(
        key: ValueKey("HomeScreen"),
      );

    // case 2:
    //   return const UploadPage(
    //     key: ValueKey("UploadPage"),
    //   );
    // case 2:
    //   return const StakeAddNodeScreen(
    //     key: ValueKey("StakeAddNodeScreen"),
    //   );
    // case 3:
    //   return const MNStatusScreen(
    //     key: ValueKey("MNStatusScreen"),
    //   );
    // case 4:
    //   return const NotificationSendPage(
    //     key: ValueKey("NotificationSendPage"),
    //   );
    // case 5:
    //   return const MNMigrateNodeScreen(
    //     key: ValueKey("MNMigrateNodeScreen"),
    //   );
    // case 6:
    //   return const MNListScreen(
    //     key: ValueKey("MNListScreen"),
    //   );
    default:
      return const HomePage(
        key: ValueKey("HomeScreen"),
      );
  }
}
