import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rckt_launch_app/src/models/AppUser.dart';
import 'package:rckt_launch_app/src/net_interface/interface.dart';
import 'package:rckt_launch_app/src/overlay/login_ovr.dart';
import 'package:rckt_launch_app/src/provider/login_notifier_provider.dart';
import 'package:rckt_launch_app/src/screen_pages/gallery_page.dart';
import 'package:rckt_launch_app/src/screen_pages/home_page.dart';
import 'package:rckt_launch_app/src/screen_pages/upload_page.dart';
import 'package:rckt_launch_app/src/support/app_sizes.dart';
import 'package:rckt_launch_app/src/support/auth_repo.dart';
import 'package:rckt_launch_app/src/support/s_p.dart';
import 'package:rckt_launch_app/src/support/secure_storage.dart';
import 'package:rckt_launch_app/src/widgets/account_widget.dart';
import 'package:rckt_launch_app/src/widgets/alert_dialogs.dart';
import 'package:rckt_launch_app/src/widgets/flat_custom_btn.dart';
import 'package:rckt_launch_app/src/widgets/responsible_center.dart';
import 'package:rckt_launch_app/globals.dart' as globals;
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

  Future<void> _submitQR() async {
    // setState(() => _submitted = true);
    try {
      bool? s;
      _qrcancelled = false;
      final netw = ref.read(networkProvider);
      var res = await netw.get("/login/qr", serverType: ComInterface.serverAUTH, debug: true);
      _checkLogin(res['token']);
      if (context.mounted) {
        s = await showQRAlertDialog(context: context, title: "QR code login", content: res["token"]);
      }

      if (s == null || s == false) {
        _qrcancelled = true;
      }
    } catch (e) {
      showAlertDialog(context: context, title: 'Error', content: e.toString());
      print(e);
    }
  }

  void _checkLogin(String qr) async {
    final netw = ref.read(networkProvider);
    final rauth = ref.read(authRepositoryProvider);
    String? token;
    await Future.doWhile(() async {
      try {
        if (_qrcancelled) {
          return false;
        }
        await Future.delayed(const Duration(seconds: 1));
        Map<String, dynamic>? res = await netw.post("/login/qr/token", body: {"token": qr}, serverType: ComInterface.serverAUTH, debug: true);
        if (res != null && res["token"] != null) {
          token = res["token"];
          await SecureStorage.write(key: globals.TOKEN_DAO, value: res["token"]);
          await SecureStorage.write(key: globals.TOKEN_REFRESH, value: res["refresh_token"]);

         http.Response resAPI = await netw.post("/users/login", body: {"name": res["name"], "email": res["email"]}, serverType: ComInterface.serverAPI, type: ComInterface.typePlain, debug: true);
          if (resAPI.statusCode != 200) {
            debugPrint("Error: ${resAPI.statusCode}");
            return true;
          }else {
            await SecureStorage.write(key: globals.ADMINPRIV, value: res["admin"].toString());
            await SecureStorage.write(key: globals.NAME, value: res["name"].toString());
            await SecureStorage.write(key: globals.EMAIL, value: res["email"].toString());
            rauth.currentUser = AppUser(name: res["name"], email: res["email"], admin: res["admin"] == 1 ? true : false);
            return false;
          }
        } else {
          return true;
        }
      } catch (e) {
        return true;
      }
    });
    if (_qrcancelled) {
      _qrcancelled = false;
      return;
    }
    if (token != null) {
      if (mounted) context.pop();
      if (mounted) {
        ref.read(loginProvider.notifier).greeting = true;
        setState(() {
        });
      }
    } else {
      if (mounted) showAlertDialog(context: context, title: "QR code login", content: "QR code login failed");
    }
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
                                  setState(() {
                                    page = 0;
                                  });
                                },
                                pageCurrent: page,
                                picture: "assets/images/home.png",
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
                                picture: "assets/images/gallery.png",
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
            Positioned(
              top: 70,
              right: 70,
              child: AccountWidget(
                  onTap: () {
                    _showOverlay(context, (response) {
                      if (response.isQR == true) {
                        // context.pop();
                        _submitQR();
                      } else {
                        Navigator.of(context).pushNamed('/login');
                      }
                    });
                  },
                  size: const Size(double.infinity, double.infinity)),
            ),
          ],
        ));
  }

  void _showOverlay(BuildContext context, Function(Response) onTap) {
    Navigator.of(context).push(LoginOverlay(onTap));
  }
}

class MenuItem extends StatelessWidget {
  final String picture;
  final int pageCurrent;
  final int page;
  final VoidCallback? onTap;

  const MenuItem({
    super.key,
    required this.page,
    required this.picture,
    required this.pageCurrent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FlatCustomButton(
        onTap: onTap,
        color: Colors.transparent,
        splashColor: Colors.black12,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: 25,
                    height: 28,
                    child: Image.asset(picture, isAntiAlias: true, color: page == pageCurrent ? Colors.black87 : Colors.black87)),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 5,
                height: 25,
                decoration: BoxDecoration(
                    color: page == pageCurrent ? Colors.black87 : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
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
    case 2:
      return const UploadPage(
        key: ValueKey("UploadPage"),
      );
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
