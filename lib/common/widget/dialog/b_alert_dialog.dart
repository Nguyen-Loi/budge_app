import 'package:flutter/material.dart';

class BAlertDialogModel<T> {
  final String title;
  final String message;
  final Map<String, T> buttons;

  const BAlertDialogModel(
      {required this.title, required this.message, required this.buttons});
}

class BDeleteDialog extends BAlertDialogModel<bool> {
  const BDeleteDialog({required String objName})
      : super(
          title: 'Delete $objName?',
          message: 'Are you sure you want to delete this $objName?',
          buttons: const {
            'CANCEL': false,
            'DELETE': true,
          },
        );
}

Future<bool> displayDeleteDialog(BuildContext context) =>
    const BDeleteDialog(objName: 'comment').present(context).then(
          (value) => value ?? false,
        );


extension Present<T> on BAlertDialogModel<T> {
  Future<T?> present(BuildContext context) {
    return showDialog<T?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: buttons.entries.map(
            (entry) {
              return TextButton(
                child: Text(
                  entry.key,
                ),
                onPressed: () {
                  Navigator.of(context).pop(
                    entry.value,
                  );
                },
              );
            },
          ).toList(),
        );
      },
    );
  }
}