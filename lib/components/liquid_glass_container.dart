import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/physics.dart';

/// A high-performance, hyper-real Liquid Glass implementation.
/// 
/// Replicates the iOS 18+ liquid glass effect using:
/// 1. Optimized BackdropFilter blur.
/// 2. GLSL shader for iridescence, specular glint, and refraction.
/// 3. Spring physics for "squishy" movement (The Wiggle).
class LiquidGlassContainer extends StatefulWidget {
  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.intensity = 1.0,
  });

  final Widget child;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final double intensity;

  @override
  State<LiquidGlassContainer> createState() => _LiquidGlassContainerState();
}

class _LiquidGlassContainerState extends State<LiquidGlassContainer>
    with SingleTickerProviderStateMixin {
  ui.FragmentProgram? _program;
  late Ticker _ticker;
  final ValueNotifier<double> _time = ValueNotifier(0.0);
  
  // Physics for the "Wiggle"
  double _wiggle = 0.0;
  double _scaleX = 1.0;
  double _scaleY = 1.0;
  late AnimationController _physicsController;
  
  @override
  void initState() {
    super.initState();
    _loadShader();
    
    _physicsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _ticker = createTicker((elapsed) {
      if (!mounted) return;
      _time.value = elapsed.inMilliseconds / 1000.0;
    });
    _ticker.start();
  }

  Future<void> _loadShader() async {
    try {
      final program = await ui.FragmentProgram.fromAsset(
        'packages/cupertino_native/lib/shaders/liquid_glass.frag',
      );
      setState(() => _program = program);
    } catch (e) {
      // Retry with local path if package path fails
      try {
        final program = await ui.FragmentProgram.fromAsset(
          'lib/shaders/liquid_glass.frag',
        );
        setState(() => _program = program);
      } catch (_) {}
    }
  }

  void _triggerWiggle(double velocity) {
    // Simple spring effect to squash/stretch the container
    final spring = SpringDescription(
      mass: 1.0,
      stiffness: 100.0,
      damping: 10.0,
    );
    
    final simulation = SpringSimulation(
      spring,
      0.0, // start
      0.0, // end
      velocity * 0.01, // velocity
    );

    _physicsController.animateWith(simulation);
    _physicsController.addListener(() {
      setState(() {
        _wiggle = _physicsController.value.abs();
        _scaleX = 1.0 + _physicsController.value * 0.05;
        _scaleY = 1.0 - _physicsController.value * 0.05;
      });
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _physicsController.dispose();
    _time.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget glassEffect = BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 25, sigmaY: 25),
      child: Container(color: Colors.white.withOpacity(0.02)),
    );

    if (_program != null) {
      glassEffect = RepaintBoundary(
        child: CustomPaint(
          painter: _LiquidGlassPainter(
            program: _program!,
            time: _time,
            intensity: widget.intensity,
            wiggle: _wiggle,
          ),
          child: glassEffect,
        ),
      );
    }

    return GestureDetector(
      onPanUpdate: (details) {
        // Trigger physics on drag
        _triggerWiggle(details.delta.dx + details.delta.dy);
      },
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.diagonal3Values(_scaleX, _scaleY, 1.0),
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                glassEffect,
                widget.child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LiquidGlassPainter extends CustomPainter {
  _LiquidGlassPainter({
    required this.program,
    required this.time,
    required this.intensity,
    required this.wiggle,
  }) : super(repaint: time);

  final ui.FragmentProgram program;
  final ValueNotifier<double> time;
  final double intensity;
  final double wiggle;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = program.fragmentShader();

    shader.setFloat(0, size.width);      // uSize.x
    shader.setFloat(1, size.height);     // uSize.y
    shader.setFloat(2, time.value);      // uTime
    shader.setFloat(3, intensity);       // uIntensity
    shader.setFloat(4, 0.5);             // uPointer.x
    shader.setFloat(5, 0.5);             // uPointer.y
    shader.setFloat(6, wiggle);          // uWiggle

    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant _LiquidGlassPainter oldDelegate) {
    return oldDelegate.intensity != intensity || oldDelegate.wiggle != wiggle;
  }
}
