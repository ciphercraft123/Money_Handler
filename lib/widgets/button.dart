import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Buttonstyle { primary, secondary, simple }

class Button extends StatelessWidget {
  final String? text;
  final Widget? child;
  final double bRadius;
  final double height;
  final double width;
  final Color? textColor;
  final bool isLoading;
  final Buttonstyle buttonStyle;
  final bool isPadding;
  final void Function() onTap;

  const Button({
    super.key,
    this.text,
    required this.onTap,
    required this.bRadius,
    required this.height,
    required this.width,
    this.textColor,
    this.isLoading = false,
    this.buttonStyle = Buttonstyle.simple,
    this.child,
    this.isPadding = false,
  });

  Color _colors() {
    switch (buttonStyle) {
      case Buttonstyle.primary:
        return const Color(0xffFAAE18);
      case Buttonstyle.secondary:
        return Colors.blue;
      case Buttonstyle.simple:
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isPadding
          ? EdgeInsets.symmetric(vertical: 5)
          : EdgeInsets.symmetric(horizontal: 50),
      child: InkWell(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        onTap: isLoading ? null : onTap,
        child: Container(
          padding: isPadding
              ? EdgeInsets.symmetric(horizontal: 10)
              : EdgeInsets.zero,
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: _colors(),
            borderRadius: BorderRadius.circular(bRadius),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : text == null
                    ? child
                    : Text(
                        text ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: textColor ?? Colors.black,
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
