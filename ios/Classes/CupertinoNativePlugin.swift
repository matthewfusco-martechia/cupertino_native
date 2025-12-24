import Flutter
import UIKit

public class CupertinoNativePlugin: NSObject, FlutterPlugin {
  public static var shared: CupertinoNativePlugin?
  public weak var registrar: FlutterPluginRegistrar?
  public weak var flutterEngine: FlutterEngine?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "cupertino_native", binaryMessenger: registrar.messenger())
    let instance = CupertinoNativePlugin()
    // Store the registrar to access its engine later
    instance.registrar = registrar
    CupertinoNativePlugin.shared = instance
    registrar.addMethodCallDelegate(instance, channel: channel)

    // Register platform view factories
    let sliderFactory = CupertinoSliderViewFactory(messenger: registrar.messenger())
    registrar.register(sliderFactory, withId: "CupertinoNativeSlider")

    let switchFactory = CupertinoSwitchViewFactory(messenger: registrar.messenger())
    registrar.register(switchFactory, withId: "CupertinoNativeSwitch")

    // Segmented control
    let segmentedFactory = CupertinoSegmentedControlViewFactory(messenger: registrar.messenger())
    registrar.register(segmentedFactory, withId: "CupertinoNativeSegmentedControl")

    let iconFactory = CupertinoIconViewFactory(messenger: registrar.messenger())
    registrar.register(iconFactory, withId: "CupertinoNativeIcon")

    let tabBarFactory = CupertinoTabBarViewFactory(messenger: registrar.messenger())
    registrar.register(tabBarFactory, withId: "CupertinoNativeTabBar")

    let popupMenuFactory = CupertinoPopupMenuButtonViewFactory(messenger: registrar.messenger())
    registrar.register(popupMenuFactory, withId: "CupertinoNativePopupMenuButton")

    let buttonFactory = CupertinoButtonViewFactory(messenger: registrar.messenger())
    registrar.register(buttonFactory, withId: "CupertinoNativeButton")

    let inputFactory = CupertinoInputViewFactory(messenger: registrar.messenger())
    registrar.register(inputFactory, withId: "CupertinoNativeInput")

    let navigationBarFactory = CupertinoNavigationBarViewFactory(messenger: registrar.messenger())
    registrar.register(navigationBarFactory, withId: "CupertinoNativeNavigationBar")

    let glassEffectContainerFactory = CupertinoGlassEffectContainerViewFactory(messenger: registrar.messenger())
    registrar.register(glassEffectContainerFactory, withId: "CupertinoNativeGlassEffectContainer")

    // Liquid glass segment control (looks like tab bar, operates as segment control)
    let liquidGlassSegmentedFactory = CupertinoLiquidGlassSegmentedControlViewFactory(messenger: registrar.messenger())
    registrar.register(liquidGlassSegmentedFactory, withId: "CupertinoNativeLiquidGlassSegmentedControl")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "dismissKeyboard":
      // End editing on the entire application window - dismisses any keyboard
      DispatchQueue.main.async {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      }
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
 
