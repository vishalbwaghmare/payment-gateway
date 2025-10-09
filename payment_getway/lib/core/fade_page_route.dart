import 'package:flutter/material.dart';

class FadePageRoute<T> extends PageRouteBuilder{
  final Widget child;
  FadePageRoute({ required this.child})
    :super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
    ) => child,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
    ) => FadeTransition(
      opacity: animation,
      child: child,
    )
  );

}