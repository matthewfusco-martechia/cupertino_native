import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class LiquidGlassDialogButtonDemo extends StatefulWidget {
  const LiquidGlassDialogButtonDemo({super.key});

  @override
  State<LiquidGlassDialogButtonDemo> createState() =>
      _LiquidGlassDialogButtonDemoState();
}

class _LiquidGlassDialogButtonDemoState
    extends State<LiquidGlassDialogButtonDemo> {
  String _lastAction = 'None';

  void _setAction(String action) {
    setState(() {
      _lastAction = action;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : CupertinoColors.label;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Liquid Glass Dialog Button'),
      ),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              // Status Display
              CNGlassEffectContainer(
                cornerRadius: 16,
                glassStyle: CNGlassStyle.regular,
                width: double.infinity,
                height: 60,
                child: Center(
                  child: Text(
                    'Last Action: $_lastAction',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Standard Alert Dialog
              _buildSectionTitle('Standard Alert Dialog', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Show Alert',
                buttonGlassStyle: 'regular',
                dialogTitle: 'Delete Item?',
                dialogMessage:
                    'This action cannot be undone. Are you sure you want to delete this item?',
                confirmButtonText: 'Delete',
                cancelButtonText: 'Cancel',
                isDestructive: true,
                isDarkMode: isDark,
                onConfirm: () async => _setAction('Deleted'),
              ),
              const SizedBox(height: 16),

              // Alert with Icon
              _buildSectionTitle('Alert with Icon', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Show Alert with Icon',
                buttonGlassStyle: 'regular',
                dialogTitle: 'Success!',
                dialogMessage: 'Your changes have been saved successfully.',
                confirmButtonText: 'OK',
                cancelButtonText: 'Cancel',
                icon: 'checkmark.circle.fill',
                iconSize: 48,
                iconColor: CupertinoColors.systemGreen,
                isDarkMode: isDark,
                onConfirm: () async => _setAction('Saved'),
              ),
              const SizedBox(height: 16),

              // Alert with One-Time Code
              _buildSectionTitle('Alert with One-Time Code', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Show OTP Dialog',
                buttonGlassStyle: 'regular',
                dialogTitle: 'Enter Verification Code',
                dialogMessage: 'Please enter the code sent to your device.',
                confirmButtonText: 'Verify',
                cancelButtonText: 'Cancel',
                oneTimeCode: '123456',
                isDarkMode: isDark,
                onConfirm: () async => _setAction('Verified'),
              ),
              const SizedBox(height: 16),

              // Clear Glass Style
              _buildSectionTitle('Clear Glass Style', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Clear Glass Button',
                buttonGlassStyle: 'clear',
                dialogTitle: 'Clear Style',
                dialogMessage: 'This button uses the clear glass style.',
                confirmButtonText: 'OK',
                cancelButtonText: 'Cancel',
                isDarkMode: isDark,
                onConfirm: () async => _setAction('Clear Glass'),
              ),
              const SizedBox(height: 16),

              // Action Sheet
              _buildSectionTitle('Action Sheet', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Show Action Sheet',
                buttonGlassStyle: 'regular',
                dialogTitle: 'Choose an Option',
                dialogMessage: 'Select one of the following options.',
                confirmButtonText: 'Option 1',
                cancelButtonText: 'Cancel',
                useActionSheet: true,
                isDarkMode: isDark,
                onConfirm: () async => _setAction('Option 1 Selected'),
              ),
              const SizedBox(height: 16),

              // Tinted Button
              _buildSectionTitle('Tinted Button', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Tinted Blue',
                buttonGlassStyle: 'regular',
                buttonTint: CupertinoColors.systemBlue,
                dialogTitle: 'Tinted Button',
                dialogMessage: 'This button has a blue tint.',
                confirmButtonText: 'OK',
                cancelButtonText: 'Cancel',
                isDarkMode: isDark,
                onConfirm: () async => _setAction('Tinted'),
              ),
              const SizedBox(height: 16),

              // Regular (Non-Destructive)
              _buildSectionTitle('Regular Confirmation', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Confirm Action',
                buttonGlassStyle: 'regular',
                dialogTitle: 'Confirm',
                dialogMessage: 'Do you want to proceed with this action?',
                confirmButtonText: 'Confirm',
                cancelButtonText: 'Cancel',
                isDestructive: false,
                isDarkMode: isDark,
                onConfirm: () async => _setAction('Confirmed'),
              ),
              const SizedBox(height: 32),

              // iOS 26 Style Examples
              _buildSectionTitle('iOS 26 Style - Multiple Actions', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Multiple Actions',
                buttonGlassStyle: 'regular',
                dialogTitle: 'Choose Action',
                dialogMessage: 'Select an action to perform.',
                isDarkMode: isDark,
                actions: [
                  AlertAction(
                    title: 'Save',
                    style: AlertActionStyle.primary,
                    onPressed: () => _setAction('Saved'),
                  ),
                  AlertAction(
                    title: 'Share',
                    style: AlertActionStyle.defaultAction,
                    onPressed: () => _setAction('Shared'),
                  ),
                  AlertAction(
                    title: 'Delete',
                    style: AlertActionStyle.destructive,
                    onPressed: () => _setAction('Deleted'),
                  ),
                  AlertAction(
                    title: 'Cancel',
                    style: AlertActionStyle.cancel,
                    onPressed: () => _setAction('Cancelled'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Text Input Dialog
              _buildSectionTitle('Text Input Dialog', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Rename Item',
                buttonGlassStyle: 'regular',
                dialogTitle: 'Rename',
                dialogMessage: 'Enter a new name for this item.',
                isDarkMode: isDark,
                input: const AdaptiveAlertDialogInput(
                  placeholder: 'Item name',
                  initialValue: 'My Item',
                  maxLength: 50,
                ),
                actions: [
                  AlertAction(
                    title: 'Rename',
                    style: AlertActionStyle.primary,
                    onPressed: () => _setAction('Renamed'),
                  ),
                  AlertAction(
                    title: 'Cancel',
                    style: AlertActionStyle.cancel,
                    onPressed: () => _setAction('Rename Cancelled'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Password Input Dialog
              _buildSectionTitle('Password Input Dialog', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Enter Password',
                buttonGlassStyle: 'regular',
                dialogTitle: 'Authentication Required',
                dialogMessage: 'Please enter your password to continue.',
                isDarkMode: isDark,
                input: const AdaptiveAlertDialogInput(
                  placeholder: 'Password',
                  obscureText: true,
                ),
                actions: [
                  AlertAction(
                    title: 'Sign In',
                    style: AlertActionStyle.primary,
                    onPressed: () => _setAction('Signed In'),
                  ),
                  AlertAction(
                    title: 'Cancel',
                    style: AlertActionStyle.cancel,
                    onPressed: () => _setAction('Sign In Cancelled'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Email Input Dialog
              _buildSectionTitle('Email Input Dialog', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Enter Email',
                buttonGlassStyle: 'regular',
                dialogTitle: 'Subscribe',
                dialogMessage: 'Enter your email address to subscribe.',
                isDarkMode: isDark,
                input: const AdaptiveAlertDialogInput(
                  placeholder: 'email@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                actions: [
                  AlertAction(
                    title: 'Subscribe',
                    style: AlertActionStyle.primary,
                    onPressed: () => _setAction('Subscribed'),
                  ),
                  AlertAction(
                    title: 'Cancel',
                    style: AlertActionStyle.cancel,
                    onPressed: () => _setAction('Subscribe Cancelled'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action Styles - Primary
              _buildSectionTitle('Action Style - Primary', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Primary Action',
                buttonGlassStyle: 'regular',
                dialogTitle: 'Primary Action',
                dialogMessage: 'This dialog uses primary action style.',
                isDarkMode: isDark,
                actions: [
                  AlertAction(
                    title: 'Continue',
                    style: AlertActionStyle.primary,
                    onPressed: () => _setAction('Primary Action'),
                  ),
                  AlertAction(
                    title: 'Cancel',
                    style: AlertActionStyle.cancel,
                    onPressed: () => _setAction('Cancelled'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action Styles - Destructive
              _buildSectionTitle('Action Style - Destructive', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Destructive Action',
                buttonGlassStyle: 'regular',
                dialogTitle: 'Delete Account?',
                dialogMessage: 'This will permanently delete your account and all data.',
                isDarkMode: isDark,
                actions: [
                  AlertAction(
                    title: 'Delete',
                    style: AlertActionStyle.destructive,
                    onPressed: () => _setAction('Account Deleted'),
                  ),
                  AlertAction(
                    title: 'Cancel',
                    style: AlertActionStyle.cancel,
                    onPressed: () => _setAction('Delete Cancelled'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action Styles - Success
              _buildSectionTitle('Action Style - Success', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Success Action',
                buttonGlassStyle: 'regular',
                dialogTitle: 'Payment Successful',
                dialogMessage: 'Your payment has been processed successfully.',
                icon: 'checkmark.circle.fill',
                iconColor: CupertinoColors.systemGreen,
                isDarkMode: isDark,
                actions: [
                  AlertAction(
                    title: 'Done',
                    style: AlertActionStyle.success,
                    onPressed: () => _setAction('Success'),
                  ),
                  AlertAction(
                    title: 'View Receipt',
                    style: AlertActionStyle.defaultAction,
                    onPressed: () => _setAction('View Receipt'),
                  ),
                  AlertAction(
                    title: 'Cancel',
                    style: AlertActionStyle.cancel,
                    onPressed: () => _setAction('Cancelled'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action Styles - Warning
              _buildSectionTitle('Action Style - Warning', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Warning Action',
                buttonGlassStyle: 'regular',
                dialogTitle: 'Low Storage',
                dialogMessage: 'Your device storage is almost full. Free up some space?',
                icon: 'exclamationmark.triangle.fill',
                iconColor: CupertinoColors.systemOrange,
                isDarkMode: isDark,
                actions: [
                  AlertAction(
                    title: 'Free Up Space',
                    style: AlertActionStyle.warning,
                    onPressed: () => _setAction('Free Up Space'),
                  ),
                  AlertAction(
                    title: 'Later',
                    style: AlertActionStyle.defaultAction,
                    onPressed: () => _setAction('Later'),
                  ),
                  AlertAction(
                    title: 'Cancel',
                    style: AlertActionStyle.cancel,
                    onPressed: () => _setAction('Cancelled'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Disabled Actions
              _buildSectionTitle('Disabled Actions', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Disabled Action',
                buttonGlassStyle: 'regular',
                dialogTitle: 'Feature Unavailable',
                dialogMessage: 'This feature is currently disabled.',
                isDarkMode: isDark,
                actions: [
                  AlertAction(
                    title: 'Enable',
                    style: AlertActionStyle.primary,
                    enabled: false,
                    onPressed: () => _setAction('Enabled'),
                  ),
                  AlertAction(
                    title: 'Cancel',
                    style: AlertActionStyle.cancel,
                    onPressed: () => _setAction('Cancelled'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Multiple Actions with Different Styles
              _buildSectionTitle('Complex Action Set', textColor),
              const SizedBox(height: 12),
              _LiquidGlassDialogButton(
                buttonText: 'Complex Actions',
                buttonGlassStyle: 'regular',
                dialogTitle: 'File Options',
                dialogMessage: 'What would you like to do with this file?',
                isDarkMode: isDark,
                actions: [
                  AlertAction(
                    title: 'Open',
                    style: AlertActionStyle.primary,
                    onPressed: () => _setAction('Opened'),
                  ),
                  AlertAction(
                    title: 'Share',
                    style: AlertActionStyle.defaultAction,
                    onPressed: () => _setAction('Shared'),
                  ),
                  AlertAction(
                    title: 'Duplicate',
                    style: AlertActionStyle.secondary,
                    onPressed: () => _setAction('Duplicated'),
                  ),
                  AlertAction(
                    title: 'Move',
                    style: AlertActionStyle.info,
                    onPressed: () => _setAction('Moved'),
                  ),
                  AlertAction(
                    title: 'Delete',
                    style: AlertActionStyle.destructive,
                    onPressed: () => _setAction('Deleted'),
                  ),
                  AlertAction(
                    title: 'Cancel',
                    style: AlertActionStyle.cancel,
                    onPressed: () => _setAction('Cancelled'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}

/// A button that triggers a native Cupertino dialog or action sheet.
/// Adapted from FFLiquidGlassDialogButton for demo use.
class _LiquidGlassDialogButton extends StatelessWidget {
  const _LiquidGlassDialogButton({
    this.width,
    this.height,
    required this.buttonText,
    this.buttonTextColor,
    this.buttonGlassStyle = 'regular',
    this.buttonTint,
    required this.dialogTitle,
    this.dialogMessage,
    // Legacy support
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
    // iOS 26 style support
    this.actions,
    this.input,
  });

  final double? width;
  final double? height;
  final String buttonText;
  final Color? buttonTextColor;
  final String buttonGlassStyle;
  final Color? buttonTint;
  final String dialogTitle;
  final String? dialogMessage;
  // Legacy support
  final String confirmButtonText;
  final String cancelButtonText;
  final bool isDestructive;
  final bool useActionSheet;
  final bool isDarkMode;
  final String? icon;
  final double? iconSize;
  final Color? iconColor;
  final String? oneTimeCode;
  final Future<void> Function()? onConfirm;
  // iOS 26 style support
  final List<AlertAction>? actions;
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
    final effectiveTextColor =
        buttonTextColor ?? (isDarkMode ? Colors.white : CupertinoColors.label);

    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: CupertinoTheme(
        data: CupertinoThemeData(
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        child: SizedBox(
          width: width ?? double.infinity,
          height: height ?? 50,
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
                        fontSize: 17.0,
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
      title: cancelButtonText,
      style: AlertActionStyle.cancel,
      onPressed: () {},
    ));
    
    // Add confirm button
    result.add(AlertAction(
      title: confirmButtonText,
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
                        // Glass Background
                        Positioned.fill(
                          child: CNGlassEffectContainer(
                            glassStyle: CNGlassStyle.regular,
                            cornerRadius: 20,
                            width: double.infinity,
                            height: double.infinity,
                            child: const SizedBox(),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                              // Title
                              Text(
                                dialogTitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                  fontFamily: 'SF Pro Text',
                                  letterSpacing: -0.41,
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
                                            : Colors.black)
                                        .withValues(alpha: 0.1),
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
                              ] else if (input != null && textController != null) ...[
                                const SizedBox(height: 12),
                                CNGlassEffectContainer(
                                  cornerRadius: 8,
                                  glassStyle: CNGlassStyle.clear,
                                  tint: (isDarkMode || isDark
                                      ? Colors.white
                                      : Colors.black).withValues(alpha: 0.1),
                                  width: double.infinity,
                                  height: 44,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: CNInput(
                                      controller: textController,
                                      placeholder: input!.placeholder,
                                      backgroundColor: CupertinoColors.transparent,
                                      borderStyle: CNInputBorderStyle.none,
                                      textColor: textColor,
                                      keyboardType: input!.keyboardType ?? TextInputType.text,
                                      isSecure: input!.obscureText,
                                    ),
                                  ),
                                ),
                              ] else if (dialogMessage != null && dialogMessage!.isNotEmpty) ...[
                                const SizedBox(height: 4),
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
                              const SizedBox(height: 20),
                              // Buttons - Vertical Stack (iOS 26 style)
                              // Primary actions first, then cancel
                              Column(
                                children: [
                                  // Other actions (primary, destructive, etc.)
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
                                    ),
                                  )),
                                  // Cancel button (always last)
                                  _GlassDialogButton(
                                    text: cancelAction.title,
                                    onPressed: () {
                                      Navigator.pop(ctx, input != null ? null : null);
                                      cancelAction.onPressed();
                                    },
                                    isPrimary: false,
                                    isDestructive: false,
                                    isDarkMode: isDarkMode || isDark,
                                  ),
                                ],
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
                  // Glass Background
                  Positioned.fill(
                    child: CNGlassEffectContainer(
                      glassStyle: CNGlassStyle.regular,
                      cornerRadius: 20,
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
                        // Action Buttons
                        ...otherActions.map((action) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _GlassDialogButton(
                            text: action.title,
                            onPressed: action.enabled ? () {
                              Navigator.pop(context);
                              action.onPressed();
                            } : null,
                            isPrimary: action.style == AlertActionStyle.primary,
                            isDestructive: action.style == AlertActionStyle.destructive,
                            isDarkMode: isDarkMode || isDark,
                            enabled: action.enabled,
                          ),
                        )),
                        const SizedBox(height: 8),
                        // Cancel Button
                        _GlassDialogButton(
                          text: cancelAction.title,
                          onPressed: () {
                            Navigator.pop(context);
                            cancelAction.onPressed();
                          },
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
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDestructive;
  final bool isDarkMode;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // iOS 26 style: Primary button is blue with white text, secondary is grey with dark text
    final textColor = !enabled
        ? (isDarkMode ? Colors.white.withValues(alpha: 0.3) : CupertinoColors.quaternaryLabel)
        : isDestructive
            ? CupertinoColors.destructiveRed
            : isPrimary
                ? Colors.white // Primary button has white text
                : (isDarkMode ? Colors.white : CupertinoColors.label); // Secondary button

    // Primary button gets blue tint, secondary gets light grey tint
    final buttonTint = isPrimary
        ? CupertinoColors.systemBlue // Blue background for primary
        : (isDarkMode
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.black.withValues(alpha: 0.05)); // Light grey for secondary

    return SizedBox(
      height: 44,
      width: double.infinity,
      child: Stack(
        children: [
          CNGlassEffectContainer(
            cornerRadius: 12,
            glassStyle: isPrimary ? CNGlassStyle.regular : CNGlassStyle.clear,
            tint: buttonTint,
            width: double.infinity,
            height: 44,
            interactive: enabled && onPressed != null,
            onTap: enabled ? onPressed : null,
            child: const SizedBox(),
          ),
          IgnorePointer(
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
        ],
      ),
    );
  }
}

