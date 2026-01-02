import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_native/components/liquid_glass_container.dart';
import 'package:cupertino_native/components/glass_effect_container.dart'; // Native version

class LiquidGlassComparisonDemo extends StatelessWidget {
  const LiquidGlassComparisonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Glass Performance: Native vs Shader'),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image to show blur effectiveness
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1557683316-973673baf926?q=80&w=1000&auto=format&fit=crop', // Neon gradient
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'NATIVE (UiKitView)',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // NATIVE VERSION
                    SizedBox(
                      height: 150,
                      child: CNGlassEffectContainer(
                        glassStyle: CNGlassStyle.regular,
                        cornerRadius: 20,
                        child: const Center(
                          child: Text(
                            'Native Blur\n(Heavy on Scroll)',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),

                    const Text(
                      'FLUTTER SHADER (LiquidGlassContainer)',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // FLUTTER SHADER VERSION
                    const SizedBox(
                      height: 150,
                      child: LiquidGlassContainer(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        intensity: 1.0,
                        child: Center(
                          child: Text(
                            'Flutter Shader Blur\n(120fps Scroll)',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    const Text(
                      'Stress Test (Many items)',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // List of Shader items
                    for (int i = 0; i < 10; i++) 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          height: 60,
                          child: LiquidGlassContainer(
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                            child: Center(child: Text('Item $i (Shader)', style: const TextStyle(color: Colors.black))),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
