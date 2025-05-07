import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:versace/core/theme/cubit/theme_cubit.dart';
import 'package:versace/core/theme/cubit/theme_state.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.light_mode,
              size: 16,
              color: state.isDarkMode 
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                  : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Switch(
              value: state.isDarkMode,
              onChanged: (value) {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.dark_mode,
              size: 16,
              color: state.isDarkMode 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
          ],
        );
      },
    );
  }
} 