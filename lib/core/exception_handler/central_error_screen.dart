import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CentralErrorScreen extends StatefulWidget {
  final FlutterErrorDetails? details;
  const CentralErrorScreen({super.key, this.details});

  @override
  State<CentralErrorScreen> createState() => _CentralErrorScreenState();
}

class _CentralErrorScreenState extends State<CentralErrorScreen> with SingleTickerProviderStateMixin {
  bool _showDetails = false;
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
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
    final colorScheme = theme.colorScheme;
    final errorMessage = widget.details?.exceptionAsString() ?? 'An unexpected error has occurred.';
    final stackTrace = widget.details?.stack?.toString();
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.shadow.withValues(alpha: 0.1),
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'Something went wrong',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
        ),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.refresh_rounded, size: 18, color: colorScheme.onSurface),
            label: Text(
              'Retry',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideUp,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ErrorIllustration(color: colorScheme.error),
                const SizedBox(height: 32),
                Text(
                  'Oops! An error occurred',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'We ran into a problem while processing your request. '
                  'Please try again or contact support if this keeps happening.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _ErrorCard(
                  icon: Icons.error_outline_rounded,
                  iconColor: colorScheme.error,
                  backgroundColor: colorScheme.errorContainer.withValues(alpha: 0.35),
                  title: 'Error Details',
                  body: errorMessage,
                ),
                if (stackTrace != null) ...[
                  const SizedBox(height: 12),
                  _CollapsibleTrace(
                    visible: _showDetails,
                    trace: stackTrace,
                    onToggle: () => setState(() => _showDetails = !_showDetails),
                    color: colorScheme.onSurfaceVariant,
                    borderColor: colorScheme.outlineVariant,
                  ),
                ],
                const SizedBox(height: 40),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    context.goNamed(AppRoutes.dashboard);
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back To Home'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorIllustration extends StatelessWidget {
  final Color color;
  const _ErrorIllustration({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 134,
      height: 134,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
      child: Icon(Icons.warning_rounded, size: 96, color: color),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String body;

  const _ErrorCard({required this.icon, required this.iconColor, required this.backgroundColor, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    height: 1.5,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsibleTrace extends StatelessWidget {
  final bool visible;
  final String trace;
  final VoidCallback onToggle;
  final Color color;
  final Color borderColor;

  const _CollapsibleTrace({required this.visible, required this.trace, required this.onToggle, required this.color, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Row(
            children: [
              Text(
                visible ? 'Hide stack trace' : 'Show stack trace',
                style: theme.textTheme.labelMedium?.copyWith(color: color),
              ),
              const SizedBox(width: 8.0),
              Icon(
                visible ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                size: 24,
                color: color,
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: visible
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    trace,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: color,
                      height: 1.6,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
