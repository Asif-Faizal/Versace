import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/bottom_nav_cubit.dart';
import '../../cubit/bottom_nav_state.dart';
import '../widgets/main_bottom_nav_bar.dart';
import 'home_screen.dart';
import 'favirites_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(state),
          bottomNavigationBar: const MainBottomNavBar(),
        );
      },
    );
  }

  Widget _buildBody(BottomNavState state) {
    return state.when(
      home: () => const HomePage(),
      favorites: () => const FavoritesScreen(),
      cart: () => const CartScreen(),
      profile: () => const ProfileScreen(),
      search: () => const SearchScreen(),
    );
  }
} 