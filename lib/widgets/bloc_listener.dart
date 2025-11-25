import 'package:admin/models/states/api_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopBlocListener<B extends BlocBase<S>, S> extends StatelessWidget {
  const PopBlocListener({
    super.key,
    required this.when,
    this.popValue,
    this.beforePop,
    required this.child,
  });
  final Object? Function(S state)? when;
  final Object? Function(S state)? popValue;
  final void Function(BuildContext context, S state)? beforePop;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listener: (context, state) {
        if (when?.call(state) != null) {
          beforePop?.call(context, state);
          Navigator.pop(context, popValue?.call(state));
        }
      },
      listenWhen: (previous, current) {
        final prevResult = when?.call(previous);
        final currResult = when?.call(current);
        return prevResult == null && currResult != null;
      },
      child: child,
    );
  }
}

class ErrorBlocListener<B extends BlocBase<S>, S> extends StatelessWidget {
  const ErrorBlocListener({
    super.key,
    required this.errorWhen,
    this.afterErrorShown,
    this.afterErrorClosed,
    required this.child,
  });
  final String? Function(S state) errorWhen;
  final void Function(BuildContext context)? afterErrorShown;
  final void Function(BuildContext context)? afterErrorClosed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listener: (context, state) async {
        final errorMessage = errorWhen(state);
        if (errorMessage != null && errorMessage.isNotEmpty) {
          final sbController = ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
            ),
          );

          afterErrorShown?.call(context);

          if (afterErrorClosed != null) {
            await sbController.closed;
            if (context.mounted) {
              afterErrorClosed?.call(context);
            }
          }
        }
      },
      listenWhen: (previous, current) {
        final prevError = errorWhen(previous);
        final currError = errorWhen(current);
        return prevError == null && currError != null;
      },
      child: child,
    );
  }
}

class ErrorsMapBlocListener<B extends BlocBase<S>, S, Key, ApiStateData>
    extends StatelessWidget {
  const ErrorsMapBlocListener({
    super.key,
    required this.errorWhen,
    required this.child,
  });
  final BuiltMap<Key, ApiState<ApiStateData>> Function(S state) errorWhen;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listenWhen: (previous, current) {
        final prevMap = errorWhen(previous);
        final nextMap = errorWhen(current);

        for (final nextKey in nextMap.keys) {
          final nextError = nextMap[nextKey]?.error;
          final prevError = prevMap[nextKey]?.error;

          if (nextError != null && prevError == null) {
            return true;
          }
        }
        return false;
      },
      listener: (context, state) {
        final errorMap = errorWhen(state);

        for (final key in errorMap.keys) {
          final error = errorMap[key]?.error?.message;
          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)),
            );
          }
        }
      },
      child: child,
    );
  }
}

class ActionBlocListener<B extends BlocBase<S>, S> extends StatelessWidget {
  const ActionBlocListener({
    super.key,
    required this.when,
    required this.listener,
    required this.child,
  });
  final Object? Function(S state) when;
  final BlocWidgetListener<S> listener;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listener: listener,
      listenWhen: (previous, current) {
        final prevResult = when(previous);
        final currResult = when(current);
        return prevResult == null && currResult != null;
      },
      child: child,
    );
  }
}
