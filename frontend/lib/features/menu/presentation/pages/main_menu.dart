import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/extension.dart';
import 'package:frontend/core/game_config.dart';
import 'package:frontend/features/adventure_levels/pixel_adventure.dart';
import 'package:frontend/features/menu/presentation/widgets/menu_button.dart';
import 'package:google_fonts/google_fonts.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              "Welcome ${GameConfig.userAddress().addressAbbreviation}",
              style: GoogleFonts.pressStart2p(fontSize: 24),
            ),
            const Spacer(),
            MainMenuButton(
              buttonText: "Play",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return GameWidget(game: PixelAdventure());
                }));
              },
            ),
            const SizedBox(height: 16),
            MainMenuButton(
              buttonText: "Weekly Challenge",
              onTap: () {},
            ),
            const SizedBox(height: 16),
            MainMenuButton(
              buttonText: "Leader board",
              onTap: () {},
            ),
            const SizedBox(height: 16),
            MainMenuButton(
              buttonText: "Settings",
              onTap: () {},
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
