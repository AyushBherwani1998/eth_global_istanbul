import 'package:frontend/core/hive_manager.dart';

class GameConfig {
  const GameConfig._();

  static bool isFirstTimeUser() {
    return HiveManager.getData(userAddressKey) == null;
  }

  static Future<void> saveUserAddress(String address) async {
    return await HiveManager.addData(userAddressKey, address);
  }

  static bool isCloudWallet() {
    return HiveManager.getData(isCloudWalletKey);
  }

  static Future<void> saveWalletType(isCloudWallet) async {
    return await HiveManager.addData(isCloudWalletKey, isCloudWallet);
  }
}
