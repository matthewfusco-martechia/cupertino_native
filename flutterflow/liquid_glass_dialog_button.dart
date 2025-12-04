// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:cupertino_native/cupertino_native.dart';

/// Action types for alert dialog buttons
enum AlertActionStyle {
  /// Default style for standard actions
  defaultAction,

  /// Cancel style for dismissing actions
  cancel,

  /// Destructive style for dangerous actions
  destructive,

  /// Primary style for emphasized actions (bold)
  primary,

  /// Secondary style for less important actions
  secondary,

  /// Success style for positive confirmations
  success,

  /// Warning style for caution actions
  warning,

  /// Info style for informational actions
  info,

  /// Disabled style for non-interactive actions
  disabled,
}

/// A single action in an alert dialog
class AlertAction {
  /// Creates an alert action
  const AlertAction({
    required this.title,
    required this.onPressed,
    this.style = AlertActionStyle.defaultAction,
    this.enabled = true,
  });

  /// The text displayed in the action button
  final String title;

  /// Called when the action is pressed
  final VoidCallback onPressed;

  /// The visual style of the action
  final AlertActionStyle style;

  /// Whether the action can be pressed
  final bool enabled;
}

/// Configuration for text input in alert dialog
class AdaptiveAlertDialogInput {
  /// Creates a text input configuration for alert dialog
  const AdaptiveAlertDialogInput({
    required this.placeholder,
    this.initialValue,
    this.keyboardType,
    this.obscureText = false,
    this.maxLength,
  });

  /// Placeholder text for the text field
  final String placeholder;

  /// Initial value for the text field
  final String? initialValue;

  /// Keyboard type for the text field
  final TextInputType? keyboardType;

  /// Whether to obscure the text (for passwords)
  final bool obscureText;

  /// Maximum length of the text input
  final int? maxLength;
}

/// A button that triggers a native Cupertino dialog or action sheet.
class FFLiquidGlassDialogButton extends StatelessWidget {
  const FFLiquidGlassDialogButton({
    super.key,
    this.width,
    this.height,
    required this.buttonText,
    this.buttonTextColor,
    this.buttonGlassStyle = 'regular',
    this.buttonTint,
    required this.dialogTitle,
    this.dialogMessage,
    // Legacy support - will be converted to actions if provided
    this.confirmButtonText = 'Confirm',
    this.cancelButtonText = 'Cancel',
    this.isDestructive = false,
    this.useActionSheet = false,
    this.isDarkMode = false,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.oneTimeCode,
    this.onConfirm,
    // New iOS 26 style support
    this.actions,
    this.input,
  });

  /// The width of the button.
  final double? width;

  /// The height of the button.
  final double? height;

  // --- Button Styling ---
  /// Text to display on the trigger button.
  final String buttonText;

  /// Color of the button text (auto-selected based on isDarkMode if not provided).
  final Color? buttonTextColor;

  /// Glass style for the trigger button.
  final String buttonGlassStyle;

  /// Optional tint color for the trigger button.
  final Color? buttonTint;

  // --- Dialog Content ---
  /// Title of the dialog/action sheet.
  final String dialogTitle;

  /// Message body of the dialog/action sheet.
  final String? dialogMessage;

  /// Text for the confirmation button.
  final String confirmButtonText;

  /// Text for the cancel button.
  final String cancelButtonText;

  /// Whether the confirm action is destructive (red).
  final bool isDestructive;

  /// Use an Action Sheet (bottom slide-up) instead of an Alert Dialog (center).
  final bool useActionSheet;

  /// Whether to use dark mode styling.
  final bool isDarkMode;

  /// Optional SF Symbol icon name (e.g., "checkmark.circle.fill")
  final String? icon;

  /// Size of the icon
  final double? iconSize;

  /// Color of the icon
  final Color? iconColor;

  /// Optional one-time code to display prominently
  final String? oneTimeCode;

  // --- Action ---
  /// Action to execute when the user confirms (legacy support).
  final Future<void> Function()? onConfirm;

  /// List of actions for the dialog (iOS 26 style).
  /// If provided, this takes precedence over confirmButtonText/cancelButtonText.
  final List<AlertAction>? actions;

  /// Optional text input configuration for the dialog.
  final AdaptiveAlertDialogInput? input;

  CNGlassStyle _resolveGlassStyle(String style) {
    switch (style.toLowerCase()) {
      case 'regular':
        return CNGlassStyle.regular;
      case 'clear':
        return CNGlassStyle.clear;
      default:
        return CNGlassStyle.regular;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine colors based on dark mode
    final effectiveTextColor = buttonTextColor ?? (isDarkMode ? Colors.white : CupertinoColors.label);

    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: CupertinoTheme(
        data: CupertinoThemeData(
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Positioned.fill(
                child: CNGlassEffectContainer(
                  cornerRadius: 16.0,
                  glassStyle: _resolveGlassStyle(buttonGlassStyle),
                  tint: buttonTint,
                  interactive: true,
                  onTap: () => _showDialog(context),
                  child: const SizedBox(),
                ),
              ),
              IgnorePointer(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      buttonText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17.0, // Standard iOS body size
                        fontWeight: FontWeight.w600,
                        color: effectiveTextColor,
                        fontFamily: 'SF Pro Text',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    // Convert legacy parameters to actions if needed
    final effectiveActions = actions ?? _buildLegacyActions();
    
    if (useActionSheet) {
      _showLiquidGlassActionSheet(context, effectiveActions);
    } else {
      _showLiquidGlassAlertDialog(context, effectiveActions);
    }
  }

  List<AlertAction> _buildLegacyActions() {
    final List<AlertAction> result = [];
    
    // Add cancel button first
    result.add(AlertAction(
      title: cancelButtonText ?? 'Cancel',
      style: AlertActionStyle.cancel,
      onPressed: () {},
    ));
    
    // Add confirm button
    result.add(AlertAction(
      title: confirmButtonText ?? 'Confirm',
      style: isDestructive ? AlertActionStyle.destructive : AlertActionStyle.primary,
      onPressed: () async {
        await onConfirm?.call();
      },
    ));
    
    return result;
  }

  void _showLiquidGlassAlertDialog(BuildContext context, List<AlertAction> actions) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode || isDark ? Colors.white : CupertinoColors.label;
    final secondaryTextColor = isDarkMode || isDark 
        ? Colors.white.withValues(alpha: 0.7) 
        : CupertinoColors.secondaryLabel;
    final effectiveIconColor = iconColor ?? CupertinoColors.systemBlue;
    
    // Separate cancel action from others
    final cancelAction = actions.firstWhere(
      (a) => a.style == AlertActionStyle.cancel,
      orElse: () => AlertAction(
        title: 'Cancel',
        style: AlertActionStyle.cancel,
        onPressed: () {},
      ),
    );
    final otherActions = actions.where((a) => a.style != AlertActionStyle.cancel).toList();
    
    // Text input controller if input is provided
    final TextEditingController? textController = input != null
        ? TextEditingController(text: input!.initialValue)
        : null;

    showGeneralDialog<String?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, anim1, anim2) {
        return Theme(
          data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          child: CupertinoTheme(
            data: CupertinoThemeData(
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  width: 270,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: IntrinsicHeight(
                    child: Stack(
                      children: [
                        // iOS Alert Background - Solid with subtle blur
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDarkMode || isDark
                                  ? const Color(0xFF1C1C1E) // Dark gray background
                                  : const Color(0xFFF2F2F7), // Light gray background
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: (isDarkMode || isDark
                                    ? Colors.white
                                    : Colors.black).withValues(alpha: 0.1),
                                width: 0.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Icon (if provided)
                              if (icon != null) ...[
                                CNIcon(
                                  symbol: CNSymbol(
                                    icon!,
                                    size: iconSize ?? 48,
                                    color: effectiveIconColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                              // Title - Left aligned (iOS HIG style)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  dialogTitle,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                    fontFamily: 'SF Pro Text',
                                    letterSpacing: -0.41,
                                    height: 1.29,
                                  ),
                                ),
                              ),
                              // Message or One-Time Code
                              if (oneTimeCode != null) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (isDarkMode || isDark
                                        ? Colors.white
                                        : Colors.black).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    oneTimeCode!,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Courier',
                                      color: textColor,
                                      letterSpacing: 2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ] else if (dialogMessage != null && dialogMessage!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                // Description - Left aligned (iOS HIG style)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    dialogMessage!,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: secondaryTextColor,
                                      fontFamily: 'SF Pro Text',
                                      letterSpacing: -0.08,
                                      height: 1.38,
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              // Buttons Container with top border separator (iOS HIG style)
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: (isDarkMode || isDark
                                          ? Colors.white
                                          : Colors.black).withValues(alpha: 0.1),
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                padding: const EdgeInsets.only(top: 8),
                                child: Builder(
                                  builder: (context) {
                                    // Buttons - Horizontal Layout
                                    // For 2 buttons: Secondary (cancel) on left, Primary on right
                                    // For 1 button: Full width
                                    // For 3+ buttons: Vertical stack
                                    if (otherActions.isEmpty) {
                                      return _GlassDialogButton(
                                        text: cancelAction.title,
                                        onPressed: () {
                                          Navigator.pop(ctx, input != null ? null : null);
                                          cancelAction.onPressed();
                                        },
                                        isPrimary: false,
                                        isDestructive: false,
                                        isDarkMode: isDarkMode || isDark,
                                        fullWidth: true,
                                      );
                                    } else if (otherActions.length == 1) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: _GlassDialogButton(
                                              text: cancelAction.title,
                                              onPressed: () {
                                                Navigator.pop(ctx, input != null ? null : null);
                                                cancelAction.onPressed();
                                              },
                                              isPrimary: false,
                                              isDestructive: false,
                                              isDarkMode: isDarkMode || isDark,
                                            ),
                                          ),
                                          Container(
                                            width: 0.5,
                                            height: 44,
                                            color: (isDarkMode || isDark
                                                ? Colors.white
                                                : Colors.black).withValues(alpha: 0.1),
                                          ),
                                          Expanded(
                                            child: _GlassDialogButton(
                                              text: otherActions.first.title,
                                              onPressed: otherActions.first.enabled ? () async {
                                                final result = input != null && textController != null
                                                    ? textController.text.trim()
                                                    : null;
                                                Navigator.pop(ctx, result);
                                                otherActions.first.onPressed();
                                              } : null,
                                              isPrimary: otherActions.first.style == AlertActionStyle.primary,
                                              isDestructive: otherActions.first.style == AlertActionStyle.destructive,
                                              isDarkMode: isDarkMode || isDark,
                                              enabled: otherActions.first.enabled,
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          ...otherActions.map((action) => Padding(
                                            padding: const EdgeInsets.only(bottom: 8),
                                            child: _GlassDialogButton(
                                              text: action.title,
                                              onPressed: action.enabled ? () async {
                                                final result = input != null && textController != null
                                                    ? textController.text.trim()
                                                    : null;
                                                Navigator.pop(ctx, result);
                                                action.onPressed();
                                              } : null,
                                              isPrimary: action.style == AlertActionStyle.primary,
                                              isDestructive: action.style == AlertActionStyle.destructive,
                                              isDarkMode: isDarkMode || isDark,
                                              enabled: action.enabled,
                                              fullWidth: true,
                                            ),
                                          )),
                                          const SizedBox(height: 8),
                                          _GlassDialogButton(
                                            text: cancelAction.title,
                                            onPressed: () {
                                              Navigator.pop(ctx, input != null ? null : null);
                                              cancelAction.onPressed();
                                            },
                                            isPrimary: false,
                                            isDestructive: false,
                                            isDarkMode: isDarkMode || isDark,
                                            fullWidth: true,
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        final curvedAnim = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(curvedAnim),
          child: FadeTransition(
            opacity: curvedAnim,
            child: child,
          ),
        );
      },
    );
  }

  void _showLiquidGlassActionSheet(BuildContext context, List<AlertAction> actions) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final secondaryTextColor = isDarkMode || isDark 
        ? Colors.white.withValues(alpha: 0.7) 
        : CupertinoColors.secondaryLabel;
    
    // Separate cancel action from others
    final cancelAction = actions.firstWhere(
      (a) => a.style == AlertActionStyle.cancel,
      orElse: () => AlertAction(
        title: 'Cancel',
        style: AlertActionStyle.cancel,
        onPressed: () {},
      ),
    );
    final otherActions = actions.where((a) => a.style != AlertActionStyle.cancel).toList();

    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Theme(
        data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        child: CupertinoTheme(
          data: CupertinoThemeData(
            brightness: isDarkMode ? Brightness.dark : Brightness.light,
          ),
          child: Container(
            margin: const EdgeInsets.all(8),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                        // Glass Background - iOS alert style with subtle blur
                        Positioned.fill(
                          child: CNGlassEffectContainer(
                            glassStyle: CNGlassStyle.regular,
                            cornerRadius: 14,
                            tint: isDarkMode || isDark
                                ? const Color(0xFF1C1C1E).withValues(alpha: 0.95)
                                : const Color(0xFFF2F2F7).withValues(alpha: 0.95),
                            width: double.infinity,
                            height: double.infinity,
                            child: const SizedBox(),
                          ),
                        ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          dialogTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: secondaryTextColor,
                            fontFamily: 'SF Pro Text',
                            letterSpacing: -0.08,
                          ),
                        ),
                        if (dialogMessage != null && dialogMessage!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          // Message
                          Text(
                            dialogMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: secondaryTextColor,
                              fontFamily: 'SF Pro Text',
                              letterSpacing: -0.08,
                              height: 1.38,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        // Action Button
                        _GlassDialogButton(
                          text: confirmButtonText,
                          onPressed: () async {
                            Navigator.pop(context);
                            await onConfirm?.call();
                          },
                          isPrimary: false,
                          isDestructive: isDestructive,
                          isDarkMode: isDarkMode || isDark,
                        ),
                        const SizedBox(height: 8),
                        // Cancel Button
                        _GlassDialogButton(
                          text: cancelButtonText,
                          onPressed: () => Navigator.pop(context),
                          isPrimary: true,
                          isDestructive: false,
                          isDarkMode: isDarkMode || isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassDialogButton extends StatelessWidget {
  const _GlassDialogButton({
    required this.text,
    required this.onPressed,
    required this.isPrimary,
    required this.isDestructive,
    required this.isDarkMode,
    this.enabled = true,
    this.fullWidth = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDestructive;
  final bool isDarkMode;
  final bool enabled;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    // iOS HIG style: Primary button is solid blue with white text, secondary is transparent with label text
    final textColor = !enabled
        ? (isDarkMode ? Colors.white.withValues(alpha: 0.3) : CupertinoColors.quaternaryLabel)
        : isDestructive
            ? CupertinoColors.destructiveRed
            : isPrimary
                ? Colors.white // Primary button has white text
                : (isDarkMode ? Colors.white : CupertinoColors.label); // Secondary button uses label color
    
    // iOS HIG style: Primary button is solid blue, secondary is dark gray (matching alert background)
    final buttonBackgroundColor = isPrimary
        ? CupertinoColors.systemBlue // Solid blue for primary
        : (isDarkMode 
            ? const Color(0xFF1C1C1E) // Dark gray background for secondary (matches alert)
            : const Color(0xFFF2F2F7)); // Light gray background for secondary

    return SizedBox(
      height: 44,
      width: fullWidth ? double.infinity : null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled && onPressed != null ? onPressed : null,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 44,
            width: fullWidth ? double.infinity : null,
            decoration: BoxDecoration(
              color: buttonBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w400,
                  color: textColor,
                  fontFamily: 'SF Pro Text',
                  letterSpacing: -0.41,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
