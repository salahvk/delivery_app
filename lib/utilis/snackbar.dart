import 'package:flutter/material.dart';

void showSnackBar(
  String message,
  BuildContext context, {
  IconData? icon,
  Color? color,
  Color backgroundColor = Colors.black,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.transparent,
    content: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(4)),
      height: 40,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Text(
                message,
                maxLines: 2,
                style: TextStyle(
                    color: color ?? Colors.white, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (icon != null) Icon(icon, color: color ?? Colors.white),
          ],
        ),
      ),
    ),
    duration: const Duration(seconds: 2),
  ));
}
