import 'package:hive_flutter/hive_flutter.dart';

const String gameConfigBoxKey = "gameConfig";
const String userAddressKey = "userAddress";
const String isCloudWalletKey = "isCloudWallet";

class HiveManager {
  const HiveManager._();

  static Box get gameConfigBox => Hive.box(gameConfigBoxKey);

  static Future<void> openBoxes() async {
    await Hive.initFlutter();
    await Hive.openBox(gameConfigBoxKey);
  }

  static Future<void> addData(String key, dynamic value) async {
    gameConfigBox.put(key, value);
  }

  static dynamic getData(String key) async {
    return gameConfigBox.get(key);
  }
}
