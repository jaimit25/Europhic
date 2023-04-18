import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/placeholder.dart';

FlatButtonC({onPressed, color, child}) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: color,
      ),
      child: child,
    ),
  );
}
