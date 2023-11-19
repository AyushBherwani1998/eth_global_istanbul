import 'package:frontend/core/curve_grid/curve_grid_provider.dart';
import 'package:frontend/core/service_locator.dart';
import 'package:frontend/core/wallet_connect/wallet_connect_handler.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class Web3Service {
  const Web3Service._();

  static CurveGridProvider get curveGridProvider =>
      ServiceLocator.getIt<CurveGridProvider>();

  static Web3Client get web3Client => ServiceLocator.getIt<Web3Client>();

  static Future<String> signAndSubmitTransaction(
    Transaction transaction, {
    bool isCloudWallet = true,
    int chainId = 421614,
  }) async {
    final gasAndGasPrice = await estimateGasAndGasPrice(transaction);

    final resolvedTransaction = Transaction(
      gasPrice: gasAndGasPrice.$2,
      maxGas: gasAndGasPrice.$1,
      from: transaction.from,
      to: transaction.to,
      data: transaction.data,
      value: transaction.value,
    );

    if (isCloudWallet) {
      final response = await curveGridProvider.signAndSubmitHSMTransaction(
        resolvedTransaction,
      );

      return response.result.tx.hash;
    } else {
      final response = await WalletConnectHandler.signTransaction(
        resolvedTransaction,
        chainId,
      );
      final hash = await web3Client.sendRawTransaction(hexToBytes(response));

      return hash;
    }
  }

  static Future<(int, EtherAmount)> estimateGasAndGasPrice(
    Transaction transaction,
  ) async {
    final gas = await web3Client.estimateGas(
      sender: transaction.from,
      to: transaction.to,
      data: transaction.data,
      value: transaction.value,
    );

    final gasPrice = await web3Client.getGasPrice();

    return (gas.toInt(), gasPrice);
  }
}
