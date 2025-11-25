import 'package:admin/widgets/text_fields/form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    super.key,
    this.enabled,
    this.initialValue,
    this.hintText,
    this.hintStyle,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.controller,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.customDefaultBorderSide,
    this.fieldKey,
    this.maxLines = 1,
    this.minLines,
    this.fillColor = const Color(0xff1D242B),
    this.autofocus = false,
    this.focusNode,
    this.customCircularBorder,
  });

  final bool? enabled;
  final String? initialValue;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final BorderSide? customDefaultBorderSide;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Key? fieldKey;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;
  final Color? fillColor;
  final GestureTapCallback? onTap;
  final FocusNode? focusNode;
  final double? customCircularBorder;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  final ValueNotifier<String> error = ValueNotifier("");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    if (widget.errorText != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          error.value = widget.errorText!;
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          error.value = "";
        }
      });
    }
    return ValueListenableBuilder(
      valueListenable: error,
      builder: (context, value, widBuilder) {
        return Column(
          children: [
            Card.filled(
              shadowColor: Colors.transparent,
              color: Colors.transparent,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: TextFormField(
                autofocus: widget.autofocus,
                focusNode: widget.focusNode,
                obscuringCharacter: '*',
                key: widget.fieldKey,
                enabled:
                    widget.enabled ?? !(AppForm.of(context)?.disable ?? false),
                initialValue: widget.initialValue,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                style: Theme.of(context).textTheme.displayMedium,
                decoration: InputDecoration(
                  hintText: widget.hintText,

                  // contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  hintStyle: widget.hintStyle ??
                      Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff9EA0A4),
                          ),
                  helperText: widget.helperText,
                  errorText: widget.errorText,
                  errorMaxLines: 10,
                  // error: errorText == null
                  //     ? null
                  //     : Row(children: [
                  //         const Icon(
                  //           Icons.error_outline,
                  //           color: Color(0xFFF9DEDC),
                  //           size: 10,
                  //         ),
                  //         SizedBox(
                  //           width: 1.w,
                  //         ),
                  //         Text(errorText!,
                  //             style: const TextStyle(
                  //                 color: Color(0xFFF9DEDC), fontSize: 10))
                  //       ]),
                  errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                  fillColor: Theme.of(context).primaryColorLight,
                  filled: true,
                  border: DecoratedInputBorder(
                    child: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.customCircularBorder ?? 10,
                      ),
                      borderSide: widget.errorText == null
                          ? widget.customDefaultBorderSide ?? BorderSide.none
                          : const BorderSide(color: Color(0xffd51820)),
                    ),
                    shadow: BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ),
                  enabledBorder: DecoratedInputBorder(
                    child: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.customCircularBorder ?? 10,
                      ),
                      borderSide: widget.errorText == null && value.isEmpty
                          ? widget.customDefaultBorderSide ?? BorderSide.none
                          : const BorderSide(color: Color(0xffd51820)),
                    ),
                    shadow: BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ),
                  disabledBorder: DecoratedInputBorder(
                    child: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.customCircularBorder ?? 10,
                      ),
                      borderSide: widget.errorText == null
                          ? BorderSide.none
                          : const BorderSide(color: Colors.grey),
                    ),
                    shadow: BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ),

                  errorBorder: DecoratedInputBorder(
                    child: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.customCircularBorder ?? 10,
                      ),
                      borderSide: const BorderSide(color: Color(0xffd51820)),
                    ),
                    shadow: BoxShadow(
                      blurStyle: BlurStyle.inner,
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ),
                  focusedErrorBorder: DecoratedInputBorder(
                    child: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.customCircularBorder ?? 10,
                      ),
                      borderSide: const BorderSide(color: Color(0xffd51820)),
                    ),
                    shadow: BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ),
                  prefixIcon: widget.prefixIcon == null
                      ? null
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: widget.prefixIcon,
                        ),
                  suffixIcon: widget.suffixIcon == null
                      ? null
                      : Padding(
                          padding: const EdgeInsetsDirectional.only(
                            end: 10,
                          ),
                          child: widget.suffixIcon,
                        ),
                  prefixIconConstraints: const BoxConstraints(),
                  suffixIconConstraints: const BoxConstraints(),
                ),
                autovalidateMode: AutovalidateMode.onUnfocus,
                // validator: widget.validator,
                validator: (value) {
                  String? result;
                  if (widget.validator != null) {
                    result = widget
                        .validator!(value); // call the user-defined validator
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        error.value = result ?? "";
                      }
                    });
                  }
                  return result; // <-- return the actual validation result
                },
                onChanged: widget.onChanged,
                inputFormatters: widget.inputFormatters,
                obscureText: widget.obscureText,
                onTap: widget.onTap,
                onFieldSubmitted: widget.onFieldSubmitted,
                autofillHints: widget.autofillHints,
                controller: widget.controller,
                textCapitalization: widget.textCapitalization,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
              ),
            ),
            // if (value.isEmpty)
            //   const SizedBox.shrink()
            // else
            //   _defaultErrorWidget(value),
          ],
        );
      },
    );
  }

  // Widget _defaultErrorWidget(String message) {
  //   return Row(
  //     children: [
  //       const SizedBox(width: 5),
  //       const Icon(Icons.error_outline, color: Color(0xffd51820), size: 12),
  //       const SizedBox(width: 5),
  //       Expanded(
  //         child: Text(
  //           message,
  //           style: const TextStyle(
  //             color: Color(0xffd51820),
  //             fontSize: 12,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

class DecoratedInputBorder extends InputBorder {
  DecoratedInputBorder({
    required this.child,
    required this.shadow,
  }) : super(borderSide: child.borderSide);

  final InputBorder child;

  final BoxShadow shadow;

  @override
  bool get isOutline => child.isOutline;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      child.getInnerPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      child.getOuterPath(rect, textDirection: textDirection);

  @override
  EdgeInsetsGeometry get dimensions => child.dimensions;

  @override
  InputBorder copyWith({
    BorderSide? borderSide,
    InputBorder? child,
    BoxShadow? shadow,
    bool? isOutline,
  }) {
    return DecoratedInputBorder(
      child: (child ?? this.child).copyWith(borderSide: borderSide),
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  ShapeBorder scale(double t) {
    final scalledChild = child.scale(t);

    return DecoratedInputBorder(
      child: scalledChild is InputBorder ? scalledChild : child,
      shadow: BoxShadow.lerp(null, shadow, t)!,
    );
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final clipPath = Path()
      ..addRect(const Rect.fromLTWH(-5000, -5000, 10000, 10000))
      ..addPath(getInnerPath(rect), Offset.zero)
      ..fillType = PathFillType.evenOdd;
    canvas.clipPath(clipPath);

    final Paint paint = shadow.toPaint();
    final Rect bounds = rect.shift(shadow.offset).inflate(shadow.spreadRadius);

    canvas.drawPath(getOuterPath(bounds), paint);

    child.paint(
      canvas,
      rect,
      gapStart: gapStart,
      gapExtent: gapExtent,
      gapPercentage: gapPercentage,
      textDirection: textDirection,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DecoratedInputBorder &&
        other.borderSide == borderSide &&
        other.child == child &&
        other.shadow == shadow;
  }

  @override
  int get hashCode => Object.hash(borderSide, child, shadow);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'DecoratedInputBorder')}($borderSide, $shadow, $child)';
  }
}
