// ignore_for_file: use_build_context_synchronously

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/curve_grid/curve_grid_provider.dart';
import 'package:frontend/core/game_config.dart';
import 'package:frontend/core/service_locator.dart';
import 'package:frontend/core/widgets/dialog.dart';
import 'package:frontend/features/login/presentation/widgets/guest_button.dart';
import 'package:frontend/features/login/presentation/widgets/wallet_connect_button.dart';
import 'package:frontend/features/menu/presentation/pages/main_menu.dart';
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
      onWalletConnectConnected(args, context);
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
                        : () async {
                            showLoader(context);
                            createCloudWalletAddress(context);
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

  Future<void> createCloudWalletAddress(BuildContext context) async {
    try {
      cloudWalletCreatingNotifier.value = true;
      final curveGridProvider = ServiceLocator.getIt<CurveGridProvider>();
      final deviceId = (await DeviceInfoPlugin().iosInfo).identifierForVendor!;
      final wallet = await curveGridProvider.createNewHSMWallet(deviceId);
      await GameConfig.saveUserAddress(wallet.azureWallet.publicAddress);
      await GameConfig.saveWalletType(true);
      cloudWalletCreatingNotifier.value = false;
      removeLoader(context);
      navigateToMenu(context);
    } catch (e, _) {
      cloudWalletCreatingNotifier.value = false;
      return;
    }
  }

  void navigateToMenu(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return const MainMenu();
      }),
    );
  }

  void _connectWallet(BuildContext context) {
    w3mService.openModal(context);
  }

  void onWalletConnectConnected(SessionConnect? args, BuildContext context) {
    if (w3mService.isConnected) {
      GameConfig.saveUserAddress(w3mService.address!);
      GameConfig.saveWalletType(false);
      navigateToMenu(context);
    }
  }
}
