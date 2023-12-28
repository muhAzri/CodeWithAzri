import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class CustomTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final TextStyle? labelTextStyle;
  final EdgeInsets? padding;
  const CustomTextButton({
    super.key,
    required this.label,
    required this.onTap,
    this.labelTextStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: InkWell(
        onTap: onTap,
        child: Text(
          label,
          style: labelTextStyle ?? grayTextStyle,
        ),
      ),
    );
  }
}
