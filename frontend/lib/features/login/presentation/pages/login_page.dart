import 'package:device_info_plus/device_info_plus.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/curve_grid/curve_grid_provider.dart';
import 'package:frontend/core/game_config.dart';
import 'package:frontend/core/service_locator.dart';
import 'package:frontend/features/login/presentation/widgets/guest_button.dart';
import 'package:frontend/features/login/presentation/widgets/wallet_connect_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final W3MService w3mService;
  late final ValueNotifier<bool> cloudWalletCreatingNotifier;

  @override
  void initState() {
    cloudWalletCreatingNotifier = ValueNotifier(false);

    w3mService = ServiceLocator.getIt<W3MService>();
    w3mService.web3App?.onSessionConnect.subscribe((args) {
      onWalletConnectConnected(args);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            "Adventure Runner",
            style: GoogleFonts.pressStart2p(fontSize: 32),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              WalletConnectButton(
                onTap: () {
                  _connectWallet(context);
                },
              ),
              const SizedBox(width: 24),
              ValueListenableBuilder<bool>(
                valueListenable: cloudWalletCreatingNotifier,
                builder: (context, isCreating, _) {
                  return GuesButton(
                    onTap: isCreating
                        ? null
                        : () {
                            createCloudWalletAddress();
                          },
                  );
                },
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Future<void> createCloudWalletAddress() async {
    try {
      cloudWalletCreatingNotifier.value = true;
      final curveGridProvider = ServiceLocator.getIt<CurveGridProvider>();
      final deviceId = (await DeviceInfoPlugin().iosInfo).identifierForVendor!;
      final wallet = await curveGridProvider.createNewHSMWallet(deviceId);
      GameConfig.saveUserAddress(wallet.azureWallet.publicAddress);
      GameConfig.saveWalletType(true);
      cloudWalletCreatingNotifier.value = false;
    } catch (e, _) {
      cloudWalletCreatingNotifier.value = false;
      return;
    }
  }

  void _connectWallet(BuildContext context) {
    w3mService.openModal(context);
  }

  void onWalletConnectConnected(SessionConnect? args) {
    if (w3mService.isConnected) {
      GameConfig.saveUserAddress(w3mService.address!);
      GameConfig.saveWalletType(false);
    }
  }
}
