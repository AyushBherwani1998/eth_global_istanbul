import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/extension.dart';
import 'package:frontend/core/game_config.dart';
import 'package:frontend/features/adventure_levels/adventure_levels.dart';
import 'package:frontend/features/adventure_runner/adventure_runner.dart';
import 'package:frontend/features/adventure_runner/componenets/overlays/game_over.dart';
import 'package:frontend/features/leaderboard/presentation/leaderboard_page.dart';
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
            GestureDetector(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: GameConfig.userAddress()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.black,
                    content: Text(
                      'Copied to your clipboard!',
                      style: GoogleFonts.pressStart2p(color: Colors.white),
                    ),
                  ),
                );
              },
              child: Text(
                "Welcome ${GameConfig.userAddress().addressAbbreviation}",
                style: GoogleFonts.pressStart2p(fontSize: 24),
              ),
            ),
            const Spacer(),
            MainMenuButton(
              buttonText: "Play",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return GameWidget(game: AdventureLevels());
                }));
              },
            ),
            const SizedBox(height: 16),
            MainMenuButton(
              buttonText: "Weekly Challenge",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return GameWidget<AdventureRunner>.controlled(
                    gameFactory: AdventureRunner.new,
                    overlayBuilderMap: {
                      "gameover": (_, game) => GameOverScreen(game: game),
                    },
                  );
                }));
              },
            ),
            const SizedBox(height: 16),
            MainMenuButton(
              buttonText: "Leader-board",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const LeaderBoardPage();
                  }),
                );
              },
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
