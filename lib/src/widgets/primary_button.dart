import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordinals_pres/src/support/app_sizes.dart';

/// Primary button based on [ElevatedButton].
/// Useful for CTAs in the app.
/// @param text - text to display on the button.
/// @param isLoading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class PrimaryButton extends StatefulWidget {
  const PrimaryButton(
      {super.key, required this.text, this.isLoading = false, this.onPressed, this.color = Colors.black, this.splashColor = Colors.black87});
  final String text;
  final bool isLoading;
  final Color? color;
  final Color? splashColor;
  final VoidCallback? onPressed;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  var b = false;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: b ? widget.splashColor : widget.color,
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(milliseconds: 200),
        child: SizedBox(
          height: Sizes.p48,
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.p8),
              ),
            ),
            onHover: (isHovering) {
              if (isHovering) {
                setState(() {
                  b = true;
                });
              }else{
                setState(() {
                  b = false;
                });
              }
            },
            child: widget.isLoading
                ? const CircularProgressIndicator()
                : Text(
              widget.text,
              textAlign: TextAlign.center,
              style: GoogleFonts.dosis(color: Colors.white70, letterSpacing: 2, fontWeight: FontWeight.w500, fontSize: Sizes.p20),
            ),
          ),
        ),
      ),
    );
  }
}
