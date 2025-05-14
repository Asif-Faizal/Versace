import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routing/routing_arguments.dart';
import '../../../../core/injection/injection_container.dart';
import '../../cubit/bottom_nav_cubit.dart';
import '../../cubit/bottom_nav_state.dart';
import '../widgets/main_bottom_nav_bar.dart';
import 'edit_profile_screen.dart';
import 'home_screen.dart';
import 'favirites_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, this.editProfileArguments});
  final EditProfileArguments? editProfileArguments;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        _showExitConfirmationDialog(context);
      },
      child: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          // Always show bottom nav bar, even for edit profile
          return Scaffold(
            body: _buildBody(state),
            bottomNavigationBar: const MainBottomNavBar(),
          );
        },
      ),
    );
  }

  // Show a dialog to confirm app exit
  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          content: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Are you sure you want to close the app?',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: OutlinedButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Close the dialog
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text('Close'),
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Close the dialog
                        // Actually exit the app by allowing the pop to proceed
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
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
      editProfile: () {
        EditProfileArguments arguments =
            editProfileArguments ??
            (getIt.isRegistered<EditProfileArguments>()
                ? getIt<EditProfileArguments>()
                : const EditProfileArguments(firstName: '', lastName: ''));

        return EditProfileScreen(arguments: arguments);
      },
    );
  }
}
