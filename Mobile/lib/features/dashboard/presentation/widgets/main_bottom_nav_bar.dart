import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/bottom_nav_cubit.dart';
import '../../cubit/bottom_nav_state.dart';

class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navCubit = context.watch<BottomNavCubit>();
    final navState = navCubit.state;
    final isSearchActive = navState.maybeWhen(search: () => true, orElse: () => false);
    final previousState = navCubit.previousState;
    
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final borderColor = isDarkMode ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1);
    
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(
            color: borderColor,
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavBarItem(
              label: 'Home',
              selected: navState.maybeWhen(
                home: () => true, 
                orElse: () => isSearchActive && previousState?.maybeWhen(home: () => true, orElse: () => false) == true
              ),
              onTap: () {
                if (!navState.maybeWhen(home: () => true, orElse: () => false)) {
                  context.read<BottomNavCubit>().select(const BottomNavState.home());
                }
              },
            ),
            _NavBarItem(
              label: 'Favorites',
              selected: navState.maybeWhen(
                favorites: () => true, 
                orElse: () => isSearchActive && previousState?.maybeWhen(favorites: () => true, orElse: () => false) == true
              ),
              onTap: () {
                if (!navState.maybeWhen(favorites: () => true, orElse: () => false)) {
                  context.read<BottomNavCubit>().select(const BottomNavState.favorites());
                }
              },
            ),
            _NavBarItem(
              label: 'Cart',
              selected: navState.maybeWhen(
                cart: () => true, 
                orElse: () => isSearchActive && previousState?.maybeWhen(cart: () => true, orElse: () => false) == true
              ),
              onTap: () {
                if (!navState.maybeWhen(cart: () => true, orElse: () => false)) {
                  context.read<BottomNavCubit>().select(const BottomNavState.cart());
                }
              },
            ),
            _NavBarItem(
              label: 'Profile',
              selected: navState.maybeWhen(
                profile: () => true, 
                orElse: () => isSearchActive && previousState?.maybeWhen(profile: () => true, orElse: () => false) == true
              ),
              onTap: () {
                if (!navState.maybeWhen(profile: () => true, orElse: () => false)) {
                  context.read<BottomNavCubit>().select(const BottomNavState.profile());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavBarItem({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    // Use primary color from colorScheme for selected items
    final selectedColor = colorScheme.primary;
    
    // Use text color from the textTheme for unselected items with reduced opacity
    final unselectedColor = textTheme.bodyMedium?.color?.withValues(alpha:  0.6);
    
    final color = selected ? selectedColor : unselectedColor;
    
    return Expanded(
      child: InkWell(
        onTap: onTap,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        child: Container(
          height: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label, 
                style: textTheme.labelMedium?.copyWith(
                  color: color, 
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(top: 2),
                height: 2,
                width: selected ? 24 : 0,
                color: selected ? color : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 