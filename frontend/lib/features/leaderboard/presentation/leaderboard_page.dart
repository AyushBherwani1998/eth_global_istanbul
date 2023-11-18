import 'package:flutter/material.dart';
import 'package:frontend/core/extension.dart';
import 'package:frontend/core/service_locator.dart';
import 'package:frontend/features/leaderboard/data/leaderboard_provider.dart';
import 'package:frontend/features/leaderboard/data/models/challenge_model.dart';
import 'package:frontend/features/login/presentation/utils/button_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({super.key});

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  late final Future<ChallengeModel> currentChallengeFuture;
  late final Future<List<int>> submittedScoresFuture;
  late final LeaderBoardProvider leaderBoardProvider;
  late final Future<int> userTicketId;

  @override
  void initState() {
    super.initState();
    leaderBoardProvider = ServiceLocator.getIt<LeaderBoardProvider>();
    currentChallengeFuture = leaderBoardProvider.viewChallenge();
    userTicketId = leaderBoardProvider.checkUserTicketId();
    // submittedScoresFuture =
    //     leaderBoardProvider.viewScoresSubmittedForCurrentChallenge();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                "Leader board",
                style: GoogleFonts.pressStart2p(),
              ),
            ),
            const Divider(
              indent: 38,
              endIndent: 38,
            ),
            FutureBuilder(
              future: currentChallengeFuture,
              builder: (context, data) {
                if (data.connectionState == ConnectionState.done) {
                  if (data.hasData) {
                    return ListTile(
                      title: Text(
                        data.data!.highScorer.addressAbbreviation,
                        style: GoogleFonts.pressStart2p(),
                      ),
                      trailing: Text(
                        data.data!.highScore.toString(),
                        style: GoogleFonts.pressStart2p(),
                      ),
                    );
                  } else if (data.hasError) {
                    return ListTile(
                      title: Text(
                        data.error.toString(),
                        style: GoogleFonts.pressStart2p(),
                      ),
                    );
                  }
                  return ListTile(
                    title: Text(
                      "Loading",
                      style: GoogleFonts.pressStart2p(),
                    ),
                  );
                }
                return ListTile(
                  title: Text(
                    "Loading",
                    style: GoogleFonts.pressStart2p(),
                  ),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 12,
              ),
              child: FutureBuilder(
                future: userTicketId,
                builder: (context, data) {
                  if (data.hasData && data.data != null && data.data! < 1) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Participate in weekly challenge with 1 APE",
                          style: GoogleFonts.pressStart2p(fontSize: 8),
                        ),
                        const SizedBox(height: 16),
                        NeoPopButton(
                          color: kSecondaryButtonLightColor,
                          bottomShadowColor: kShadowColorDarkGreen,
                          rightShadowColor: kShadowColorGreen,
                          buttonPosition: Position.fullBottom,
                          depth: kButtonDepth,
                          onTapUp: () {},
                          border: Border.all(
                            color: kBorderColorGreen,
                            width: kButtonBorderWidth,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 8.0,
                            ),
                            child: Center(
                              child: Text(
                                "Participate",
                                style: GoogleFonts.pressStart2p(
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  return const Offstage();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
