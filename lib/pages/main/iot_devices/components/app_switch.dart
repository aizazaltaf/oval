import 'package:flutter/material.dart';

class AppSwitchWidget extends StatelessWidget {
  const AppSwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.text = "",
    this.thumbSize = 40.0, // Set the default thumb size
  });

  final bool value;
  final String text;
  final ValueChanged<bool> onChanged;
  final double thumbSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onChanged(!value);
        },
        onHorizontalDragStart: (details) {
          if (!value) {
            // Swipe Left → turn OFF
            onChanged(true);
          } else if (value) {
            // Swipe Right → turn ON
            onChanged(false);
          }
        },
        child: Container(
          width: thumbSize * 2.6,
          // Adjust the width for the entire switch
          height: thumbSize,
          // Adjust the height for the thumb size
          padding: const EdgeInsets.all(1.2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(thumbSize),
            color: value ? const Color(0xff0082b0) : Colors.grey,
          ),
          child: Row(
            children: [
              if (value)
                Expanded(
                  child: Center(
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 5.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              Align(
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: thumbSize,
                  height: thumbSize,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
              if (!value)
                Expanded(
                  child: Center(
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 5.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
