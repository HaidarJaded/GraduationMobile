import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/models/user_model.dart';
import 'package:graduation_mobile/pages/client/cubit/switch_cubit/switch_cubit.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final User? user;
  final bool initialSwitchValue;

  CustomAppBar(
      {super.key,
      this.user,
      required this.initialSwitchValue,
      String? userName,
      String? userEmail});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SwitchCubit(initialSwitchValue),
      child: BlocBuilder<SwitchCubit, SwitchState>(
        builder: (context, state) {
          bool switchValue = state is SwitchInitial
              ? state.switchValue
              : (state as SwitchChanged).switchValue;

          return AppBar(
            backgroundColor: const Color.fromARGB(255, 87, 42, 170),
            title: const Text('MYP'),
            actions: [
              Switch(
                value: switchValue,
                onChanged: (value) {
                  context.read<SwitchCubit>().toggleSwitch(user!.id as int);
                  if (user != null) {
                    user!.atWork = value ? 1 : 0;
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
