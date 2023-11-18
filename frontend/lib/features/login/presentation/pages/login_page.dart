import 'package:flutter/material.dart';
import 'package:frontend/features/login/presentation/widgets/guest_button.dart';
import 'package:frontend/features/login/presentation/widgets/wallet_connect_button.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            "Adventure Runner",
            style: GoogleFonts.pressStart2p(fontSize: 32),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: WalletConnectButton(
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: GuesButton(
                  onTap: () {},
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
