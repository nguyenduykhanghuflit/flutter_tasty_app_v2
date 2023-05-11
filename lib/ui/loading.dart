import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_overlay/flutter_overlay.dart';
class LoadingOverlay extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  LoadingOverlay({required this.child, required this.isLoading});

  @override
  _LoadingOverlayState createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: SpinKitCircle(
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ),
      ],
    );
  }
}