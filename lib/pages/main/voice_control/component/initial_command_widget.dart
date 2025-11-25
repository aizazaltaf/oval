import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:flutter/material.dart';

class InitialCommandWidget extends StatelessWidget {
  const InitialCommandWidget({
    super.key,
    required this.text,
    required this.bloc,
    required this.ctx,
  });
  final VoiceControlBloc bloc;
  final String text;
  final BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        bloc
          ..recordTypeText(
            ctx,
            typedText: text,
            fromUseModal: true,
          )
          ..updateIsTyping(false)
          ..updateTypingCommand(null);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
