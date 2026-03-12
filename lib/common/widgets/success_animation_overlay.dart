import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Animated success overlay: scale + fade checkmark with message.
/// Similar to clock-in/out success. Use in dialogs or overlays.
class SuccessAnimationOverlay extends StatefulWidget {
  const SuccessAnimationOverlay({
    super.key,
    required this.message,
    this.icon = Symbols.check_circle,
    this.iconSize = 120,
  });

  final String message;
  final IconData icon;
  final double iconSize;

  @override
  State<SuccessAnimationOverlay> createState() =>
      _SuccessAnimationOverlayState();
}

class _SuccessAnimationOverlayState extends State<SuccessAnimationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Material(
      color: cs.surface,
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scale,
              child: FadeTransition(
                opacity: _opacity,
                child: Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: cs.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeTransition(
              opacity: _opacity,
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows success animation in a dialog, auto-closes after [autoCloseDuration].
Future<void> showSuccessAnimationDialog(
  BuildContext context, {
  required String message,
  IconData icon = Symbols.check_circle,
  Duration autoCloseDuration = const Duration(milliseconds: 1200),
}) async {
  final barrierColor = Theme.of(context).brightness == Brightness.light
      ? Colors.black26
      : Colors.black54;
  await showDialog<void>(
    context: context,
    barrierColor: barrierColor,
    barrierDismissible: false,
    builder: (context) => _AutoCloseSuccessDialog(
      message: message,
      icon: icon,
      autoCloseDuration: autoCloseDuration,
    ),
  );
}

class _AutoCloseSuccessDialog extends StatefulWidget {
  const _AutoCloseSuccessDialog({
    required this.message,
    required this.icon,
    required this.autoCloseDuration,
  });

  final String message;
  final IconData icon;
  final Duration autoCloseDuration;

  @override
  State<_AutoCloseSuccessDialog> createState() =>
      _AutoCloseSuccessDialogState();
}

class _AutoCloseSuccessDialogState extends State<_AutoCloseSuccessDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(widget.autoCloseDuration, () {
        if (mounted) Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SuccessAnimationOverlay(
        message: widget.message,
        icon: widget.icon,
      ),
    );
  }
}
