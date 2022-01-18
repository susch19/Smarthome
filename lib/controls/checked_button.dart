import 'package:flutter/material.dart';

Widget checkedButton({required Widget child, bool isChecked = false, Function? onPressed}) {
  return isChecked
      ? Opacity(
          opacity: 1,
          child: OutlinedButton(
            onPressed: () => onPressed?.call(),
            child: child,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ))
      : Opacity(
          opacity: 0.4,
          child: TextButton(
            onPressed: () => onPressed?.call(),
            child: child,
          ));
}
