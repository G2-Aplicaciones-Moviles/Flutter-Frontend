import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool outlined;
  final bool small;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.outlined = false,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final height = small ? 34.0 : 48.0;
    final fontSize = small ? 13.0 : 16.0;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: outlined ? Colors.white : AppColors.primary,
      foregroundColor: outlined ? AppColors.textDark : Colors.white,
      elevation: 0,
      side: outlined ? const BorderSide(color: AppColors.textDark) : BorderSide.none,
      minimumSize: Size(double.infinity, height),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
    );

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Text(text),
      ),
    );
  }
}
