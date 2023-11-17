class HSMCreateWallet {
    final int status;
    final String message;
    final AzureWallet azureWallet;

    HSMCreateWallet({
        required this.status,
        required this.message,
        required this.azureWallet,
    });

    factory HSMCreateWallet.fromJson(Map<String, dynamic> json) => HSMCreateWallet(
        status: json["status"],
        message: json["message"],
        azureWallet: AzureWallet.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": azureWallet.toJson(),
    };
}

class AzureWallet {
    final String keyName;
    final String keyVersion;
    final String publicAddress;

    AzureWallet({
        required this.keyName,
        required this.keyVersion,
        required this.publicAddress,
    });

    factory AzureWallet.fromJson(Map<String, dynamic> json) => AzureWallet(
        keyName: json["keyName"],
        keyVersion: json["keyVersion"],
        publicAddress: json["publicAddress"],
    );

    Map<String, dynamic> toJson() => {
        "keyName": keyName,
        "keyVersion": keyVersion,
        "publicAddress": publicAddress,
    };
}
