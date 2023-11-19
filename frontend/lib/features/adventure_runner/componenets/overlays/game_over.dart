// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/core/service_locator.dart';
import 'package:frontend/core/widgets/dialog.dart';
import 'package:frontend/features/adventure_runner/adventure_runner.dart';
import 'package:frontend/features/leaderboard/data/leaderboard_provider.dart';
import 'package:frontend/features/menu/presentation/widgets/menu_button.dart';
import 'package:google_fonts/google_fonts.dart';

class GameOverScreen extends StatefulWidget {
  final AdventureRunner game;

  const GameOverScreen({super.key, required this.game});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  late final Future<int> userTicket;
  late final LeaderBoardProvider leaderBoardProvider;

  @override
  void initState() {
    leaderBoardProvider = ServiceLocator.getIt<LeaderBoardProvider>();
    userTicket = leaderBoardProvider.checkUserTicketId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              widget.game.score.toString(),
              style: GoogleFonts.pressStart2p(
                fontSize: 48,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "GAME\nOVER",
              style: GoogleFonts.pressStart2p(
                fontSize: 32,
                color: Colors.white60,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              children: [
                const Spacer(),
                FutureBuilder<int>(
                  future: userTicket,
                  builder: (context, data) {
                    if (data.hasData) {
                      return MainMenuButton(
                        buttonText: "Submit",
                        onTap: () async {
                          try {
                            showLoader(context);
                            final _ = await leaderBoardProvider.submitScore(
                              widget.game.score,
                            );
                            removeLoader(context);
                            Navigator.pop(context);
                          } catch (e, _) {
                            removeLoader(context);
                          }
                        },
                      );
                    }
                    return const Offstage();
                  },
                ),
                const SizedBox(width: 24),
                MainMenuButton(
                  buttonText: "Home",
                  onTap: () {
                    Navigator.pop(widget.game.buildContext!);
                  },
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
