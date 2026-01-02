import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:cupertino_native/components/button.dart';
import 'package:cupertino_native/channel/platform_view_metrics.dart';

// Helper to access private or protected members if needed, 
// or just use public API. We can rely on widget tree inspection.

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    CupertinoNativeConfig.platformViewsEnabled = true;
    PlatformViewMetrics.reset();
  });

  group('PlatformView Performance Tests', () {
    testWidgets('CNButton renders UiKitView on iOS by default', (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      
      await tester.pumpWidget(
        const CupertinoApp(
          home: CNButton(label: 'Test Button'),
        ),
      );

      expect(find.byType(UiKitView), findsOneWidget);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('CNButton renders Placeholder/Fallback when active=false', (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      
      await tester.pumpWidget(
        const CupertinoApp(
          home: CNButton(label: 'Test Button', active: false),
        ),
      );

      // Should NOT find UiKitView
      expect(find.byType(UiKitView), findsNothing);
      // Should find a SizedBox (standard fallback for inactive in many components)
      // or check that it's empty.
      
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('Global Kill-Switch disables UiKitView', (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      CupertinoNativeConfig.platformViewsEnabled = false;
      
      await tester.pumpWidget(
        const CupertinoApp(
          home: CNButton(label: 'Test Button'),
        ),
      );

      // Should NOT find UiKitView
      expect(find.byType(UiKitView), findsNothing);
      expect(find.byType(CupertinoButton), findsOneWidget); // Fallback

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('PlatformViewGuard avoids recreating view on same config', (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      
      // 1. Initial Pump
      await tester.pumpWidget(
        const CupertinoApp(
          home: CNButton(key: ValueKey('stable_btn'), label: 'Stable'),
        ),
      );
      
      final widget1 = tester.widget(find.byType(KeyedSubtree));
      print('Widget 1 hash: ${widget1.hashCode}');
      
      // 2. Pump SAME config (with same key)
      await tester.pumpWidget(
        const CupertinoApp(
          home: CNButton(key: ValueKey('stable_btn'), label: 'Stable'),
        ),
      );
      
      final widget2 = tester.widget(find.byType(KeyedSubtree));
      print('Widget 2 hash: ${widget2.hashCode}');
      
      // Expect identical widget instance (cached)
      expect(widget2, same(widget1));
      
      // 3. Pump DIFFERENT config (with same key to ensure State is kept but updated)
      await tester.pumpWidget(
        const CupertinoApp(
          home: CNButton(key: ValueKey('stable_btn'), label: 'Changed'),
        ),
      );
      
      final widget3 = tester.widget(find.byType(KeyedSubtree));
      print('Widget 3 hash: ${widget3.hashCode}');
      
      // Expect different widget instance (recreated due to config change)
      expect(widget3, isNot(same(widget1)));
      
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
