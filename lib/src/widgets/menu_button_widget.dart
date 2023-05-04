import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordinals_pres/src/support/app_sizes.dart';
import 'package:ordinals_pres/src/widgets/flat_custom_btn.dart';

class MenuButtonRowWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final IconData icon;
  const MenuButtonRowWidget({Key? key, required this.onTap, required this.text, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatCustomButton(
          height: 50,
          width: double.infinity,
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: Colors.lightGreen),
              gapW8,
              Text(text, style: GoogleFonts.roboto(fontSize: 16, color:  Colors.blueGrey )),
            ],
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.black12,
        ),
      ],
    );

  }
}
