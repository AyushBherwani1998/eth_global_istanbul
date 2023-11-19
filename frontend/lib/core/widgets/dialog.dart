import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingDialog extends StatelessWidget {
  final Widget? child;

  final bool canceable;

  const LoadingDialog({
    Key? key,
    this.child,
    this.canceable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canceable,
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: child ??
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Center(
                    child: CupertinoActivityIndicator(
                      radius: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Loading",
                    style: GoogleFonts.pressStart2p(),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

void showLoader(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => LoadingDialog(
      canceable: false,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.3,
        child: const Center(
          child: CupertinoActivityIndicator(
            radius: 18.0,
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

void removeLoader(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}
