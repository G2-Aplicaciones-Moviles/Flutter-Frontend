import 'package:flutter/material.dart';

class LogoHeader extends StatelessWidget {
  final double size;
  final String asset;
  final bool showText;

  const LogoHeader({
    super.key,
    this.size = 120,
    this.asset = 'assets/images/logo3.png',
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(asset, height: size),
        if (showText) const SizedBox(height: 10),
        if (showText)
          const Text(
            'JameoFit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Colors.black,
            ),
          ),
      ],
    );
  }
}
