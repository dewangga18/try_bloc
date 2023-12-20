import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_bloc/bloc/app_bloc.dart';
import 'package:try_bloc/bloc/app_event.dart';
import 'package:try_bloc/dialogs/delete_dialog.dart';
import 'package:try_bloc/dialogs/log_out_dialog.dart';

enum MenuButton { delete, logout }

class MainPopMenu extends StatelessWidget {
  const MainPopMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuButton>(
      onSelected: (value) {
        if (value == MenuButton.delete) {
          showDeleteDialog(context).then((value) {
            if (value) {
              context.read<AppBloc>().add(AppEventDeleteAccount());
            }
          });
        } else {
          showLogoutDialog(context).then((value) {
            if (value) {
              context.read<AppBloc>().add(AppEventLogout());
            }
          });
        }
      },
      itemBuilder: (_) {
        return [
          const PopupMenuItem<MenuButton>(
            value: MenuButton.logout,
            child: Text('Log Out'),
          ),
          const PopupMenuItem<MenuButton>(
            value: MenuButton.delete,
            child: Text('Delete Account'),
          ),
        ];
      },
    );
  }
}
