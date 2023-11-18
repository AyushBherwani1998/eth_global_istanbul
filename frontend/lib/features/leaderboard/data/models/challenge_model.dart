class ChallengeModel {
  final int status;
  final int startTime;
  final int endTime;
  final int priceTicketInApe;
  final int treasuryFee;
  final int amountCollectedInApe;
  final int highScore;
  final String highScorer;

  ChallengeModel({
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.priceTicketInApe,
    required this.treasuryFee,
    required this.amountCollectedInApe,
    required this.highScore,
    required this.highScorer,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) => ChallengeModel(
        status: json["status"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        priceTicketInApe: json["priceTicketInAPE"],
        treasuryFee: json["treasuryFee"],
        amountCollectedInApe: json["amountCollectedInAPE"],
        highScore: json["highScore"],
        highScorer: json["highScorer"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "startTime": startTime,
        "endTime": endTime,
        "priceTicketInAPE": priceTicketInApe,
        "treasuryFee": treasuryFee,
        "amountCollectedInAPE": amountCollectedInApe,
        "highScore": highScore,
        "highScorer": highScorer,
      };
}
