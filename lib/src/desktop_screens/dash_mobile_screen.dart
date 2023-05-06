import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ordinals_pres/src/provider/gallery_provider.dart';
import 'package:ordinals_pres/src/screen_pages/gallery_page.dart';
import 'package:ordinals_pres/src/screen_pages/home_page.dart';
import 'package:ordinals_pres/src/support/app_sizes.dart';
import 'package:ordinals_pres/src/widgets/menu_item.dart';
import 'package:ordinals_pres/src/widgets/responsible_center.dart';


// lib/src/desktop_screens/reference_screen.dart
class MobileDashBoardScreen extends ConsumerStatefulWidget {
  const MobileDashBoardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileDashBoardScreen> createState() => _DesktopDashScreenState();
}

class _DesktopDashScreenState extends ConsumerState<MobileDashBoardScreen> with SingleTickerProviderStateMixin {
  var page = 0;
  var _qrcancelled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveCenter(
        maxContentWidth: 500,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(5),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          gapW4,
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
                          gapW96,
                          MenuItemMobile(
                            width: 50,
                            height: 50,
                            page: 0,
                            onTap: () {
                              setState(() {
                                page = 0;
                              });
                            },
                            pageCurrent: page,
                            picture: "assets/images/home.png",
                          ),
                          gapW48,
                          MenuItemMobile(
                            width: 50,
                            height: 50,
                            page: 1,
                            onTap: () {
                              ref.invalidate(galleryProvider);
                              setState(() {
                                page = 1;
                              });
                            },
                            pageCurrent: page,
                            picture: "assets/images/gallery.png",
                          ),
                        ],
                      )
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        reverseDuration: const Duration(milliseconds: 100),
                        switchInCurve: Curves.decelerate,
                        switchOutCurve: Curves.bounceIn,
                        child: returnPage(page),
                      ),
                    ),
                  ),
                ])));
  }
}



Widget returnPage(int page) {
  switch (page) {
    case 0:
      return const HomePage(
        key: ValueKey("HomeScreen"),
      );
    case 1:
      return const GalleryPage(
        key: ValueKey("GalleryPage"),
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
