import 'package:admin/extensions/context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionSheetUtils {
  const ActionSheetUtils._();

  static Future<T?> show<T>({
    required final BuildContext context,
    final String? title,
    required final List<ActionSheetAction> actions,
  }) async {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (final ctx) => CupertinoActionSheet(
        title: title == null
            ? null
            : Text(
                title,
              ),
        actions: [
          for (int i = 0; i < actions.length; i++) ...[
            CupertinoActionSheetAction(
              onPressed: () {
                actions[i].onTap?.call(ctx);
                if (actions[i].autoPop) {
                  Navigator.pop(ctx);
                }
              },
              isDestructiveAction: actions[i].isDestructive,
              child: Text(
                actions[i].title,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: Navigator.of(ctx).pop,
          child: Text(
            context.appLocalizations.general_cancel,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ActionSheetAction {
  ActionSheetAction({
    required this.title,
    this.autoPop = true,
    this.isDestructive = false,
    this.onTap,
  });
  final String title;
  final bool autoPop;
  final bool isDestructive;
  final void Function(BuildContext)? onTap;
}
