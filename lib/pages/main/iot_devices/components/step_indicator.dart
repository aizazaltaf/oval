import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });
  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);
    return SizedBox(
      width: 40.0.w,
      child: Row(
        children: List.generate(totalSteps * 2 - 1, (index) {
          if (index.isEven) {
            // Circle step
            final int stepNumber = index ~/ 2 + 1;
            final bool isActive = stepNumber <= currentStep;
            return GestureDetector(
              onTap: () {
                if (currentStep != 1) {
                  bloc.updateCurrentFormStep(totalSteps - 1);
                }
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color.fromRGBO(4, 130, 176, 1)
                      : Colors.grey[400],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "$stepNumber",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          } else {
            // Connector line
            final bool isActive = (index ~/ 2 + 1) < currentStep;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (currentStep != 1) {
                    bloc.updateCurrentFormStep(totalSteps - 1);
                  }
                },
                child: Container(
                  height: 3,
                  color: isActive
                      ? const Color.fromRGBO(4, 130, 176, 1)
                      : Colors.grey[400],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
