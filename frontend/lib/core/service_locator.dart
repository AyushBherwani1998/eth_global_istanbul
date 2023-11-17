import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class ServiceLocator {
  const ServiceLocator._();

  static GetIt get getIt => GetIt.instance;

  static Future<void> init() async {
    final Web3Client web3client = Web3Client(
      dotenv.env["RPC_URL"] as String,
      http.Client(),
    );

    getIt.registerLazySingleton<Web3Client>(() => web3client);
  }
}
