import 'package:flutter/material.dart';
import 'package:frontend/features/login/presentation/utils/button_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

class WalletConnectButton extends StatelessWidget {
  final VoidCallback onTap;
  const WalletConnectButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeoPopButton(
      color: kPrimaryButtonColor,
      buttonPosition: Position.fullBottom,
      depth: kButtonDepth,
      onTapUp: onTap,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
          child: Text(
            "WalletConnect",
            style: GoogleFonts.pressStart2p(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
