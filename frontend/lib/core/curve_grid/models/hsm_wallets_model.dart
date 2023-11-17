class HSMWalletsModel {
    final int status;
    final String message;
    final List<Wallet> wallets;

    HSMWalletsModel({
        required this.status,
        required this.message,
        required this.wallets,
    });

    factory HSMWalletsModel.fromJson(Map<String, dynamic> json) => HSMWalletsModel(
        status: json["status"],
        message: json["message"],
        wallets: List<Wallet>.from(json["result"].map((x) => Wallet.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(wallets.map((x) => x.toJson())),
    };
}

class Wallet {
    final String clientId;
    final String baseGroupName;
    final String vaultName;
    final String keyName;
    final String keyVersion;
    final String publicAddress;

    Wallet({
        required this.clientId,
        required this.baseGroupName,
        required this.vaultName,
        required this.keyName,
        required this.keyVersion,
        required this.publicAddress,
    });

    factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        clientId: json["clientID"],
        baseGroupName: json["baseGroupName"],
        vaultName: json["vaultName"],
        keyName: json["keyName"],
        keyVersion: json["keyVersion"],
        publicAddress: json["publicAddress"],
    );

    Map<String, dynamic> toJson() => {
        "clientID": clientId,
        "baseGroupName": baseGroupName,
        "vaultName": vaultName,
        "keyName": keyName,
        "keyVersion": keyVersion,
        "publicAddress": publicAddress,
    };
}
