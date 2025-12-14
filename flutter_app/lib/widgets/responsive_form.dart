import 'package:flutter/material.dart';

class ResponsiveForm extends StatelessWidget {
  final Widget child;

  const ResponsiveForm({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth > 500 ? 500 : double.infinity;

        return Align(
          alignment: Alignment.topCenter,
          child:SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          ),
          );
           
      },
    );
  }
}
