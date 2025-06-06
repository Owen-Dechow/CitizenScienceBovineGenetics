import 'package:flutter/material.dart';

class Submitting extends StatefulWidget {
  final Widget child;
  final bool toggled;

  const Submitting({super.key, required this.child, required this.toggled});

  @override
  State<Submitting> createState() => _SubmittingState();
}

class _SubmittingState extends State<Submitting> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: widget.toggled,
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 400),
              alignment: Alignment.center,
              child: widget.child,
            ),
          ),
        ),
        if (widget.toggled)
          Container(
            color: Colors.black.withAlpha(120),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
