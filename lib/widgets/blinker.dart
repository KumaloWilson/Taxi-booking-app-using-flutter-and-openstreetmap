import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class BlinkingMarker extends StatefulWidget {
  const BlinkingMarker({
    required this.point,
    required this.color,
    required this.size,
    required this.duration,
    required this.child,
  });

  final LatLng point;
  final Color color;
  final double size;
  final Duration duration;
  final Widget child;

  @override
  _BlinkingMarkerState createState() => _BlinkingMarkerState();
}

class _BlinkingMarkerState extends State<BlinkingMarker>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle: controller.value * 2.0 * 3.14159265358979323846,
          child: Icon(
            Icons.location_on,
            color: widget.color.withOpacity(controller.value),
            size: widget.size,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}