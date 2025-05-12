import 'package:flutter/material.dart';
import '../../cubit/auto_scroll_cubit.dart';
import '../../cubit/auto_scroll_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:versace/core/injection/injection_container.dart';

class AutoScrollText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double itemWidth;
  final Duration scrollDuration;
  final EdgeInsets margin;

  const AutoScrollText({
    super.key,
    required this.text,
    this.style,
    this.itemWidth = 400,
    this.scrollDuration = const Duration(milliseconds: 1000),
    this.margin = const EdgeInsets.symmetric(horizontal: 8),
  });

  @override
  State<AutoScrollText> createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScrollText> with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AutoScrollCubit _cubit;
  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _cubit = getIt<AutoScrollCubit>(
      param1: _scrollController,
      param2: 0.0,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureTextWidth();
    });
  }

  void _measureTextWidth() {
    final RenderBox? renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final textWidth = renderBox.size.width;
      if (textWidth > 0) {
        _cubit.updateTextWidth(textWidth);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get theme-related properties outside the BlocBuilder for efficiency
    final primaryColor = Theme.of(context).primaryColor;
    final defaultColor = widget.style?.color;
    
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<AutoScrollCubit, AutoScrollState>(
        buildWhen: (previous, current) => 
          previous.currentIndex != current.currentIndex || 
          previous.totalItems != current.totalItems,
        builder: (context, state) {
          return GestureDetector(
            onTapDown: (_) => context.read<AutoScrollCubit>().pauseScrolling(),
            onTapUp: (_) => context.read<AutoScrollCubit>().resumeScrolling(),
            child: SizedBox(
              height: 40,
              child: Stack(
                children: [
                  // Hidden text for measurement
                  Positioned(
                    left: -9999,
                    child: Text(
                      widget.text,
                      key: _textKey,
                      style: widget.style,
                    ),
                  ),
                  // Scrollable text with smooth animation
                  ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.totalItems * 3,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final isCurrentIndex = index % state.totalItems == state.currentIndex;
                      
                      // Use AnimatedDefaultTextStyle for smooth text color transitions
                      return Container(
                        width: widget.itemWidth,
                        margin: widget.margin,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                            style: widget.style?.copyWith(
                              color: isCurrentIndex 
                                  ? primaryColor 
                                  : defaultColor,
                            ) ?? TextStyle(
                              color: isCurrentIndex 
                                  ? primaryColor 
                                  : Colors.black,
                            ),
                            child: Text(widget.text),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 