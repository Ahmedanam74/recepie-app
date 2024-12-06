import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomizedContainer extends StatelessWidget {
  const CustomizedContainer({
    super.key,
    required this.svg,
    required this.text,
    required this.color,
    this.onTap,
    required this.textColor,
  });
  final String svg;
  final String text;
  final Color color;
  final Color textColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svg,
              width: 50,
              height: 50,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w500, color: textColor),
            )
          ],
        ),
      ),
    );
  }
}
