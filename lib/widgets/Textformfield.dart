import 'package:money_handler/controller/password_controller.dart';
import 'package:money_handler/utils/ColorsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TextformField extends StatefulWidget {
  final String hinttext;
  final IconData? icon;
  final TextEditingController? textController;
  final bool isPassword;
  final bool isPadding;
  final FormFieldValidator<dynamic>? validator;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? keyboardType;
  final Function()? onSubmit;

  const TextformField({
    super.key,
    required this.hinttext,
    this.icon,
    this.textController,
    this.isPassword = false,
    required this.isPadding,
    required this.validator,
    this.onSubmit,
    this.keyboardType,
    this.inputFormatter,
  });

  @override
  State<TextformField> createState() => _TextformFieldState();
}

class _TextformFieldState extends State<TextformField> {
  RxBool isValue = false.obs;

  final controller = Get.put(PasswordController());
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.isPadding
          ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
          : EdgeInsets.zero,
      child: widget.isPassword
          ? Obx(
              () => TextFormField(
                controller: widget.textController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: controller.isShow.value,
                focusNode: focusNode,
                autofocus: true,
                onChanged: (value) {
                  isValue.value = value.isNotEmpty;
                },
                decoration: InputDecoration(
                  prefixIcon: widget.icon == null ? null : Icon(widget.icon),
                  hintText: widget.hinttext,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  fillColor: ColorsUtil.lightBg,
                  filled: true,
                  suffixIcon: isValue.value
                      ? InkWell(
                          onTap: () {
                            controller.passwordToggle();
                          },
                          child: controller.isShow.value
                              ? const Icon(Icons.visibility_rounded)
                              : const Icon(Icons.visibility_off),
                        )
                      : const SizedBox(),
                ),
                validator: widget.validator,
                onTapOutside: (event) {
                  focusNode.unfocus();
                },
              ),
            )
          : TextFormField(
              controller: widget.textController,
              keyboardType: widget.keyboardType ?? TextInputType.text,
              focusNode: focusNode,
              inputFormatters: widget.inputFormatter,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                prefixIcon: widget.icon == null ? null : Icon(widget.icon),
                hintText: widget.hinttext,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                fillColor: ColorsUtil.lightBg,
                filled: true,
              ),
              onTapOutside: (event) {
                focusNode.unfocus();
              },
              autofocus: true,
              validator: widget.validator,
            ),
    );
  }
}
