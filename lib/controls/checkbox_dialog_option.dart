import 'package:flutter/material.dart';

class CheckboxDialogOption extends SimpleDialogOption {
  
   const CheckboxDialogOption({
    final Key? key,
    final onPressed,
    final padding,
    final child,
  }) : super(key: key, onPressed: onPressed, padding: padding, child:child);
}