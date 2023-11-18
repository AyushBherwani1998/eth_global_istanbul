import 'package:flutter/material.dart';
import 'package:frontend/features/login/presentation/utils/button_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

class MainMenuButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;

  const MainMenuButton({
    super.key,
    required this.buttonText,
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
      child: SizedBox(
        width: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: Center(
            child: Text(
              buttonText,
              style: GoogleFonts.pressStart2p(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
