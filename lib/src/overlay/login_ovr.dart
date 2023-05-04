import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ordinals_pres/src/support/app_sizes.dart';
import 'package:ordinals_pres/src/widgets/flat_custom_btn.dart';

class LoginOverlay extends ModalRoute<void> {
  Function(Response)? onTap;

  LoginOverlay(Function(Response)? onTapped) {
    onTap = onTapped;
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  var show = false;
  String? config;

  final TextEditingController loginCTRL = TextEditingController();
  final TextEditingController passwordCTRL = TextEditingController();

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                const AutoSizeText(
                  'Login',
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                ),
                gapH32,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                  width: MediaQuery.of(context).size.width * 0.2,
                  child:  Center(
                    child: TextField(
                      controller: loginCTRL,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Username',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Center(
                    child: TextField(
                      controller: passwordCTRL,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Username',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FlatCustomButton(
                  radius: 8,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  onTap: () {
                    // context.read(configProvider).setConfig(mnIndex);
                    onTap!(Response(username: loginCTRL.text, password: passwordCTRL.text, isLogin: true));
                    Navigator.pop(context);
                  },
                  text: 'Login',
                  width: double.infinity,
                  height: 50,
                  // fontSize: MediaQuery.of(context).size.width * 0.02,
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.black12,
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                ),
                const SizedBox(height: 20),
                FlatCustomButton(
                  radius: 8,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  onTap: () {
                    // context.read(configProvider).setConfig(mnIndex);
                    onTap!(Response(isQR: true));
                    Navigator.pop(context);
                  },
                  width: double.infinity,
                  height: 50,
                  // fontSize: MediaQuery.of(context).size.width * 0.02,
                  color: Colors.white,
                  splashColor: Colors.amber,
                  borderColor: Colors.black38,
                  borderWidth: 1,
                  textColor: Colors.white,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(Icons.qr_code_2_rounded, color: Colors.black87, size: 25,),
                    SizedBox(width: 10),
                    AutoSizeText('QR login', style: TextStyle(color: Colors.black87, fontSize: 22), maxLines: 1,),
                  ],),
                ),
              ],),
    )),
    ],
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class Response {
  final String? username;
  final String? password;
  final bool isLogin;
  final bool isQR;
  Response ({this.username, this.password, this.isLogin = false,this.isQR = false});
}
