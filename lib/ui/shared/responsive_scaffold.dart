import 'package:flutter/material.dart';

class ResponsiveMobileScaffold extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveMobileScaffold({
    super.key,
    required this.child,
    this.maxWidth = 430,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= maxWidth) {
          return child;
        }
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
