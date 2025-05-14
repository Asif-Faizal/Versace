import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routing/routing_arguments.dart';
import '../../cubit/bottom_nav_cubit.dart';
import '../../cubit/bottom_nav_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.arguments});
  final EditProfileArguments arguments;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.arguments.firstName);
    _lastNameController = TextEditingController(text: widget.arguments.lastName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.read<BottomNavCubit>().select(const BottomNavState.profile());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Go back to previous state using the cubit
              context.read<BottomNavCubit>().select(const BottomNavState.profile());
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      child: Text(
                        (_firstNameController.text.isNotEmpty ? _firstNameController.text[0].toUpperCase() : '') +
                        (_lastNameController.text.isNotEmpty ? _lastNameController.text[0].toUpperCase() : ''),
                        style: textTheme.displayMedium?.copyWith(color: Colors.white),
                      ),
                    ),
                    Positioned(
                      right: 7,
                      bottom: 7,
                      child: IconButton(
                        onPressed: () {
                          // Handle profile picture change
                        },
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text('First Name', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your first name',
                ),
              ),
              const SizedBox(height: 20),
              Text('Last Name', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your last name',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}