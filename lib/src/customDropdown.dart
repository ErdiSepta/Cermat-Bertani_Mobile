import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;
  final String? errorText;
  final bool? enabled;

  const CustomDropdown({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
    this.enabled,
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text(
                hintText,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'NotoSanSemiBold',
                ),
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'NotoSanSemiBold',
                    ),
                  ),
                );
              }).toList(),
              onChanged: enabled ?? true ? onChanged : null,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontFamily: 'NotoSanSemiBold',
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
