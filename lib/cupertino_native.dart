// Public exports and convenience API for the plugin.

export 'cupertino_native_platform_interface.dart';
export 'cupertino_native_method_channel.dart';
export 'components/slider.dart';
export 'components/switch.dart';
export 'components/segmented_control.dart';
export 'components/icon.dart';
export 'components/tab_bar.dart';
export 'components/popup_menu_button.dart';
export 'style/sf_symbol.dart';
export 'style/button_style.dart';
export 'components/button.dart';
export 'components/input.dart';
export 'components/navigation_bar.dart';
export 'components/glass_effect_container.dart';
export 'components/liquid_glass_text_field.dart';
export 'components/liquid_glass_icon_container.dart';
export 'components/liquid_glass_icon_popup_menu_button.dart';
export 'components/cupertino_icon_button.dart';
export 'components/cupertino_slideable_list_tile.dart';
export 'components/liquid_glass_input_dialog.dart';
export 'components/liquid_glass_message_input.dart';
export 'components/liquid_glass_search_text_field.dart';
export 'components/liquid_glass_segmented_control.dart';

import 'package:flutter/services.dart';
import 'cupertino_native_platform_interface.dart';

/// Top-level facade for simple plugin interactions.
class CupertinoNative {
  static const MethodChannel _channel = MethodChannel('cupertino_native');

  /// Returns a user-friendly platform version string supplied by the
  /// platform implementation.
  Future<String?> getPlatformVersion() {
    return CupertinoNativePlatform.instance.getPlatformVersion();
  }

  /// Dismisses the keyboard by ending editing on the native iOS side.
  /// Call this when tapping outside a text field to hide the keyboard.
  static Future<void> dismissKeyboard() async {
    try {
      await _channel.invokeMethod('dismissKeyboard');
    } catch (_) {
      // Fallback to Flutter method if native fails
      try {
        await SystemChannels.textInput.invokeMethod('TextInput.hide');
      } catch (_) {}
    }
  }
}
