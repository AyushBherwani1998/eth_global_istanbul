import 'package:frontend/core/curve_grid/curve_grid_provider.dart';
import 'package:frontend/core/game_config.dart';
import 'package:frontend/features/leaderboard/data/models/challenge_model.dart';

class LeaderBoardProvider {
  final CurveGridProvider curveGridProvider;

  LeaderBoardProvider({required this.curveGridProvider});

  Future<int> viewCurrentChallengeId() async {
    final result = await curveGridProvider.callContractReadFunction(
      contractLabel: 'weekly_challenges',
      contractType: 'weekly_challenge',
      methodName: "currentChallengeId",
      args: [],
    );

    return int.parse(result.result.output.toString());
  }

  Future<ChallengeModel> viewChallenge() async {
    final currentChallengeId = await viewCurrentChallengeId();
    final result = await curveGridProvider.callContractReadFunction(
      contractLabel: 'weekly_challenges',
      contractType: 'weekly_challenge',
      methodName: "viewChallenge",
      args: [currentChallengeId],
    );

    return ChallengeModel.fromJson(
      Map<String, dynamic>.from(result.result.output),
    );
  }

  Future<List<int>> viewScoresSubmittedForCurrentChallenge() async {
    final currentChallengeId = await viewCurrentChallengeId();
    final result = await curveGridProvider.callContractReadFunction(
      contractLabel: 'weekly_challenges',
      contractType: 'weekly_challenge',
      methodName: "viewChallenge",
      args: [GameConfig.userAddress(), currentChallengeId],
    );

    final list = List.from(result.result.output);
    final scores = list.map((e) => int.parse(e.toString()));
    return scores.toList();
  }

  Future<int> checkUserTicketId() async {
    final currentChallengeId = await viewCurrentChallengeId();
    final result = await curveGridProvider.callContractReadFunction(
      contractLabel: 'weekly_challenges',
      contractType: 'weekly_challenge',
      methodName: "viewUserTicketId",
      args: [currentChallengeId, GameConfig.userAddress()],
    );

    return int.parse(result.result.output.toString());
  }
}
