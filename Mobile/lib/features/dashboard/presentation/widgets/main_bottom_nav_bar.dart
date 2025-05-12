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
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavBarItem(
            label: 'Home',
            selected: navState.maybeWhen(home: () => true, orElse: () => false),
            onTap: () {
              if (!navState.maybeWhen(home: () => true, orElse: () => false)) {
                context.read<BottomNavCubit>().select(const BottomNavState.home());
              }
            },
          ),
          _NavBarItem(
            label: 'Favorites',
            selected: navState.maybeWhen(favorites: () => true, orElse: () => false),
            onTap: () {
              if (!navState.maybeWhen(favorites: () => true, orElse: () => false)) {
                context.read<BottomNavCubit>().select(const BottomNavState.favorites());
              }
            },
          ),
          _NavBarItem(
            label: 'Cart',
            selected: navState.maybeWhen(cart: () => true, orElse: () => false),
            onTap: () {
              if (!navState.maybeWhen(cart: () => true, orElse: () => false)) {
                context.read<BottomNavCubit>().select(const BottomNavState.cart());
              }
            },
          ),
          _NavBarItem(
            label: 'Profile',
            selected: navState.maybeWhen(profile: () => true, orElse: () => false),
            onTap: () {
              if (!navState.maybeWhen(profile: () => true, orElse: () => false)) {
                context.read<BottomNavCubit>().select(const BottomNavState.profile());
              }
            },
          ),
        ],
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
    final color = selected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium?.color;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: TextStyle(color: color, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
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