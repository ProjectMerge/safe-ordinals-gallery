import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rckt_launch_app/src/provider/login_notifier_provider.dart';
import 'package:rckt_launch_app/src/provider/title_provider.dart';
import 'package:rckt_launch_app/src/support/auth_repo.dart';
import 'package:rckt_launch_app/src/widgets/concave_clip_container.dart';
import 'package:rckt_launch_app/src/widgets/flat_custom_btn.dart';

class AccountWidget extends ConsumerStatefulWidget {
  final Size size;
  final VoidCallback? onTap;

  const AccountWidget({Key? key, required this.size, this.onTap}) : super(key: key);

  @override
  ConsumerState<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends ConsumerState<AccountWidget> {
  bool loggedIN = false;
  bool onHover = false;

  @override
  void initState() {
    super.initState();
    isLoggedIn();
  }
  isLoggedIn() async {
    var auth = ref.read(authRepositoryProvider);
    auth.checkIfLoggedIn();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (auth.currentUser != null) {
        setState(() {
          loggedIN = true;
        });
      } else {
        setState(() {
          loggedIN = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loggedIN) {
      var tit = ref
          .watch(loginProvider)
          .greeting;
      if (tit == true) {
        setState(() {
          loggedIN = true;
        });
      }
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        FlatCustomButton(
          onHover: (isHovering) {
            if (isHovering) {
              setState(() {
                onHover = true;
              });
            } else {
              setState(() {
                onHover = false;
              });
            }
          },
          onTap: () {
            if (!loggedIN) {
              widget.onTap!();
            } else {
              //TODO: profile
            }
          },
          child: ArcCutOutContainer(
            height: 50,
            width: 200,
            arcRadius: 18,
            borderRadius: 10,
            isLeftSide: false,
            child: Container(
              decoration: BoxDecoration(
                color: onHover ? Colors.white : Colors.white70,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                  child: AutoSizeText(
                !loggedIN ? "Tap to login" : ref.read(authRepositoryProvider).currentUser!.name,
                maxLines: 1,
                minFontSize: 8.0,
              )),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 235),
          child: CircleAvatar(
            radius: 34,
            child: Icon(Icons.person),
          ),
        ),
      ],
    );
  }
}
