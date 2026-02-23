import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_text_field.dart';

/// Password TextField พร้อม show/hide toggle
class PasswordField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String? errorText;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final bool autofocus;
  final FocusNode? focusNode;

  const PasswordField({
    super.key,
    this.label = 'รหัสผ่าน',
    this.hint,
    this.controller,
    this.enabled = true,
    this.validator,
    this.onChanged,
    this.errorText,
    this.textInputAction,
    this.onSubmitted,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      hint: widget.hint ?? '••••••',
      prefixIcon: Icons.lock_outline,
      controller: widget.controller,
      obscureText: _obscureText,
      enabled: widget.enabled,
      keyboardType: TextInputType.visiblePassword,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      validator: widget.validator,
      onChanged: widget.onChanged,
      errorText: widget.errorText,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Colors.grey[600],
          size: 20,
        ),
        onPressed: _toggleVisibility,
      ),
    );
  }
}

/// Confirm Password TextField สำหรับยืนยันรหัสผ่าน
class ConfirmPasswordField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? passwordToMatch;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String? errorText;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final bool autofocus;
  final FocusNode? focusNode;

  const ConfirmPasswordField({
    super.key,
    this.label = 'ยืนยันรหัสผ่าน',
    this.hint,
    this.controller,
    this.passwordToMatch,
    this.enabled = true,
    this.validator,
    this.onChanged,
    this.errorText,
    this.textInputAction,
    this.onSubmitted,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  State<ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? _validateConfirmPassword(String? value) {
    if (widget.validator != null) {
      final result = widget.validator!(value);
      if (result != null) return result;
    }

    if (value == null || value.isEmpty) {
      return 'กรุณายืนยันรหัสผ่าน';
    }

    if (widget.passwordToMatch != null && value != widget.passwordToMatch) {
      return 'รหัสผ่านไม่ตรงกัน';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      hint: widget.hint ?? '••••••',
      prefixIcon: Icons.lock_outline,
      controller: widget.controller,
      obscureText: _obscureText,
      enabled: widget.enabled,
      keyboardType: TextInputType.visiblePassword,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      validator: widget.passwordToMatch != null ? _validateConfirmPassword : widget.validator,
      onChanged: widget.onChanged,
      errorText: widget.errorText,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Colors.grey[600],
          size: 20,
        ),
        onPressed: _toggleVisibility,
      ),
    );
  }
}
