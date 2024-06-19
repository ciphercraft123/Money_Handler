import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContainerWidget extends StatefulWidget {
  final double height;
  final double width;
  final double borderRadius;
  final String text;
  final Color iconcolor;
  final double amount;
  final IconData icon;
  final List<Color> colors;

  const ContainerWidget({
    super.key,
    required this.height,
    required this.width,
    required this.borderRadius,
    required this.text,
    required this.iconcolor,
    required this.icon,
    required this.colors,
    required this.amount,
  });

  @override
  State<ContainerWidget> createState() => _ContainerWidgetState();
}

class _ContainerWidgetState extends State<ContainerWidget> {
  RxDouble am = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        gradient: LinearGradient(
          colors: widget.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.text,
                style: const TextStyle(fontSize: 25),
              ),
              Icon(
                widget.icon,
                color: widget.iconcolor,
                size: 30,
              )
            ],
          ),
          Text(
            widget.amount.toString(),
            style: TextStyle(color: widget.iconcolor),
          ),
        ],
      ),
    );
  }
}
