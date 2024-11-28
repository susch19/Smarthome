import 'package:flutter/material.dart';

class CheckboxDialogOption extends SimpleDialogOption {
  
   const CheckboxDialogOption({
    super.key,
    final onPressed,
    final padding,
    final child,
  }) : super(onPressed: onPressed, padding: padding, child:child);
}