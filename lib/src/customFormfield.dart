import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final String? errorText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final TextStyle? style; // tambahkan parameter ini
  final bool enabled; // Tambahkan ini

  const CustomFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    this.errorText,
    this.suffixIcon,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.style, // tambahkan parameter ini
    this.enabled = true, // Tambahkan ini dengan nilai default true
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty)
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontFamily: 'NotoSanSemiBold',
            ),
          ),
        if (labelText.isNotEmpty) const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textAlign: textAlign,
          maxLength: maxLength,
          onChanged: onChanged,
          enabled: enabled, // Tambahkan ini
          decoration: InputDecoration(
            hintText: hintText,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            errorText: errorText,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
