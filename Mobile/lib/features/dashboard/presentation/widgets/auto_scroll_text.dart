import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/auto_scroll_cubit.dart';
import 'package:versace/core/injection/injection_container.dart';

class AutoScrollText extends StatelessWidget {
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
    this.scrollDuration = const Duration(milliseconds: 30),
    this.margin = const EdgeInsets.symmetric(horizontal: 8),
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AutoScrollCubit>(),
      child: _AutoScrollTextView(
        text: text,
        style: style,
        itemWidth: itemWidth,
        margin: margin,
      ),
    );
  }
}

class _AutoScrollTextView extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double itemWidth;
  final EdgeInsets margin;

  const _AutoScrollTextView({
    required this.text,
    this.style,
    required this.itemWidth,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    // Get direct theme colors
    final primaryColor = Theme.of(context).colorScheme.primary;
    final cubit = context.read<AutoScrollCubit>();
    
    // Initialize scroll controller after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!cubit.scrollController.hasClients) return;
    });
    
    return BlocBuilder<AutoScrollCubit, AutoScrollState>(
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: ListView.builder(
            controller: cubit.scrollController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.totalItems,
            itemBuilder: (context, index) {
              // Highlight one item every 10 positions
              final isHighlighted = index % 10 == 0;
              
              return Container(
                width: itemWidth,
                margin: margin,
                child: Center(
                  child: Text(
                    text,
                    style: (style ?? TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    )).copyWith(
                      color: isHighlighted ? primaryColor : null,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
} 