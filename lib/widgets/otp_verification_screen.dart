import 'dart:async';

import 'package:admin/extensions/context.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.function,
    required this.number,
  });

  final VoidCallback function;
  final String number;

  static const routeName = 'otp_verification_screen';

  static Future<void> push({
    required BuildContext context,
    required VoidCallback function,
    required String number,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => OtpVerificationScreen(
        function: function,
        number: number,
      ),
    );
  }

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    timerFunction();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> timerFunction() async {
    _timer = Timer(const Duration(seconds: 1), () {
      widget.function.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackIcon: false,
      appTitle: context.appLocalizations.otp.toUpperCase(),
      body: NoGlowListViewWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 80,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                context.appLocalizations.verified,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.w500, fontSize: 24),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                context.appLocalizations.otp_verification_text.replaceAll(
                  "99",
                  widget.number.isEmpty
                      ? ''
                      : widget.number.substring(
                          widget.number.length - 2,
                        ),
                ),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightGreyColor,
                    ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Center(
                child: CircularProgressIndicator(),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                "Proceeding ...",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
