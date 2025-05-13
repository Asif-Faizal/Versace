import 'package:flutter/material.dart';

class GradientImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? overlayContent;
  final double topGradientIntensity;
  final double bottomRightGradientIntensity;
  final EdgeInsets contentPadding;
  final String title;
  final String subtitle;
  final void Function() onPressed;
  const GradientImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.overlayContent,
    this.topGradientIntensity = 0.7,
    this.bottomRightGradientIntensity = 1,
    this.contentPadding = const EdgeInsets.all(16.0),
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base image - using FittedBox to respect intrinsic size
          Image.asset(imagePath, width: width, height: height, fit: fit),

          // Top black gradient (fades from top to bottom)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withValues(alpha: topGradientIntensity),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Bottom right gradient (fades from bottom right to top left)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topLeft,
                  colors: [
                    Colors.black.withValues(
                      alpha: bottomRightGradientIntensity,
                    ),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
          ),

          Positioned(
            top: 5,
            right: 5,
            child: TextButton(
              onPressed: onPressed,
              child: Text(
                subtitle,
                style: textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 15,
            left: 15,
            child: Text(
              title,
              style: textTheme.displayMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Optional overlay content (text, buttons, etc.)
          if (overlayContent != null)
            Positioned.fill(
              child: Padding(padding: contentPadding, child: overlayContent),
            ),
        ],
      ),
    );
  }
}
