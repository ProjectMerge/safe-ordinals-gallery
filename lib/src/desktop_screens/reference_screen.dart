import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rckt_launch_app/src/provider/title_provider.dart';
import 'package:rckt_launch_app/src/screen_pages/home_page.dart';
import 'package:rckt_launch_app/src/support/animated_clip_rect.dart';
import 'package:rckt_launch_app/src/support/app_sizes.dart';
import 'package:rckt_launch_app/src/widgets/flat_custom_btn.dart';
import 'package:rckt_launch_app/src/widgets/menu_button_widget.dart';
import 'package:rckt_launch_app/src/widgets/responsible_center.dart';
// lib/src/desktop_screens/reference_screen.dart
class OldReferenceScreen extends ConsumerStatefulWidget {
  const OldReferenceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OldReferenceScreen> createState() => _DesktopDashScreenState();
}

class _DesktopDashScreenState extends ConsumerState<OldReferenceScreen> with SingleTickerProviderStateMixin {
  bool _stakingTile = false;
  bool _mnTile = false;
  bool _miscTile = false;
  var page = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(titleProvider).greeting = "Dashboard";
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveCenter(
        maxContentWidth: 1440,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.only(top: 100, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 150,
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
                      Material(
                        color: Colors.blueGrey,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: InkWell(
                          customBorder: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              page = 0;
                            });
                          },
                          splashColor: Colors.black54,
                          hoverColor: Colors.blue,
                          child: const SizedBox(
                            width: double.infinity,
                            height: 80,
                            child: Center(
                                child: Column(
                              children: [
                                gapH20,
                                Icon(
                                  Icons.home,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Home",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                      FlatCustomButton(
                        height: 50,
                        rowAling: false,
                        color: _stakingTile ? Colors.blueGrey.shade100.withOpacity(0.6) : Colors.white,
                        splashColor: Colors.blueGrey.shade100.withOpacity(0.6),
                        radius: 0,
                        width: double.infinity,
                        onTap: () {
                          setState(() {
                            _stakingTile = !_stakingTile;
                          });
                        },
                        child: Row(
                          children: [
                            gapW8,
                            Icon(Icons.wallet_rounded, size: 22, color: !_stakingTile ? Colors.black54 : Colors.lightGreen),
                            gapW8,
                            Text("Staking", style: GoogleFonts.lato(fontSize: 16, color: !_stakingTile ? Colors.blueGrey : Colors.black54)),
                          ],
                        ),
                      ),
                      AnimatedClipRect(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(milliseconds: 300),
                        // height: _stakingTile ? 200 : 0,
                        // width: double.infinity,
                        open: _stakingTile,
                        verticalAnimation: true,
                        horizontalAnimation: false,
                        child: Column(
                          children: [
                            MenuButtonRowWidget(
                              icon: Icons.info_outline,
                              text: "Status",
                              onTap: () {
                                setState(() {
                                  page = 1;
                                });
                              },
                            ),
                            MenuButtonRowWidget(
                              icon: Icons.add,
                              text: "Add coins",
                              onTap: () {
                                setState(() {
                                  page = 2;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.black12,
                      ),
                      FlatCustomButton(
                        height: 50,
                        rowAling: false,
                        color: _mnTile ? Colors.blueGrey.shade100.withOpacity(0.6) : Colors.white,
                        splashColor: Colors.blueGrey.shade100.withOpacity(0.6),
                        radius: 0,
                        width: double.infinity,
                        onTap: () {
                          setState(() {
                            _mnTile = !_mnTile;
                          });
                        },
                        child: Row(
                          children: [
                            gapW8,
                            Icon(Icons.webhook, size: 22, color: !_mnTile ? Colors.black54 : Colors.lightGreen),
                            gapW8,
                            Text("Masternodes", style: GoogleFonts.lato(fontSize: 16, color: !_mnTile ? Colors.blueGrey : Colors.black54)),
                          ],
                        ),
                      ),
                      AnimatedClipRect(
                        curve: Curves.decelerate,
                        duration: const Duration(milliseconds: 500),
                        // height: _stakingTile ? 200 : 0,
                        // width: double.infinity,
                        open: _mnTile,
                        verticalAnimation: true,
                        horizontalAnimation: false,
                        child: Column(
                          children: [
                            MenuButtonRowWidget(
                              icon: Icons.info_outline,
                              text: "Status",
                              onTap: () {
                                setState(() {
                                  page = 3;
                                });
                              },
                            ),
                            MenuButtonRowWidget(
                              icon: Icons.swap_horiz,
                              text: "Migrate",
                              onTap: () {
                                setState(() {
                                  page = 5;
                                });
                              },
                            ),
                            MenuButtonRowWidget(
                              icon: Icons.settings,
                              text: "Manage",
                              onTap: () {
                                setState(() {
                                  page = 6;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.black12,
                      ),
                      FlatCustomButton(
                        height: 50,
                        rowAling: false,
                        color: _miscTile ? Colors.blueGrey.shade100.withOpacity(0.6) : Colors.white,
                        splashColor: Colors.blueGrey.shade100.withOpacity(0.6),
                        radius: 0,
                        width: double.infinity,
                        onTap: () {
                          setState(() {
                            _miscTile = !_miscTile;
                          });
                        },
                        child: Row(
                          children: [
                            gapW8,
                            Icon(Icons.notifications, size: 22, color: !_miscTile ? Colors.black54 : Colors.lightGreen),
                            gapW8,
                            Text("Notifications", style: GoogleFonts.lato(fontSize: 16, color: !_miscTile ? Colors.blueGrey : Colors.black54)),
                          ],
                        ),
                      ),
                      AnimatedClipRect(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(milliseconds: 500),
                        // height: _stakingTile ? 200 : 0,
                        // width: double.infinity,
                        open: _miscTile,
                        verticalAnimation: true,
                        horizontalAnimation: false,
                        child: Column(
                          children: [
                            MenuButtonRowWidget(
                              icon: Icons.send,
                              text: "Send",
                              onTap: () {
                                setState(() {
                                  page = 4;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.black12,
                      ),
                    ],
                  )),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white70, Colors.blueGrey.shade200.withOpacity(0.7)],
                      ),
                    ),
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
            ])));
  }
}

Widget returnPage(int page) {
  switch (page) {
    case 0:
      return const HomePage(
        key: ValueKey("HomeScreen"),
      );
    // case 1:
    //   return const StakeStatusScreen(
    //     key: ValueKey("StakeStatusScreen"),
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
