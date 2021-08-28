import 'package:flutter/material.dart';

class CheckboxDialogOption extends SimpleDialogOption {
  
   const CheckboxDialogOption({
    Key? key,
    onPressed,
    padding,
    child,
  }) : super(key: key, onPressed: onPressed, padding: padding, child:child);
}