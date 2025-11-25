import 'package:admin/widgets/cubit.dart';
import 'package:admin/widgets/navigator/bloc/pilot_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'pilot_state.dart';

abstract class PilotBloc extends WCCubit<PilotState> {
  PilotBloc() : super(PilotState());

  static NavigatorState navigator<TBloc extends WCCubit<PilotState>>(
    final BuildContext context,
  ) =>
      BlocProvider.of<TBloc>(context).state.navigatorKey.currentState!;
}
