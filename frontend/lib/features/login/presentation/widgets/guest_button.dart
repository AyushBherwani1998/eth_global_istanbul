import 'package:flutter/material.dart';
import 'package:frontend/features/login/presentation/utils/button_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/neopop.dart';

class GuesButton extends StatelessWidget {
  final VoidCallback onTap;

  const GuesButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeoPopButton(
      color: kSecondaryButtonLightColor,
      bottomShadowColor: kShadowColorDarkGreen,
      rightShadowColor: kShadowColorGreen,
      buttonPosition: Position.fullBottom,
      depth: kButtonDepth,
      onTapUp: onTap,
      border: Border.all(
        color: kBorderColorGreen,
        width: kButtonBorderWidth,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 15.0,
          ),
          child: Text(
            "Guest",
            style: GoogleFonts.pressStart2p(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
