import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/password_field.dart';
import '../../widgets/common/loading_button.dart';

/// โหมดของหน้า Auth
enum AuthMode { login, register }

/// AuthScreen - หน้า Login/Register รวมกันพร้อม Toggle
class AuthScreen extends ConsumerStatefulWidget {
  final AuthMode initialMode;

  const AuthScreen({
    super.key,
    this.initialMode = AuthMode.login,
  });

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  late AuthMode _mode;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _displayNameFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  String? _emailError;
  String? _passwordError;
  String? _displayNameError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _displayNameFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _clearErrors() {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _displayNameError = null;
      _confirmPasswordError = null;
    });
    ref.read(authProvider.notifier).clearError();
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode == AuthMode.login ? AuthMode.register : AuthMode.login;
      _clearErrors();
      // Clear form
      _emailController.clear();
      _passwordController.clear();
      _displayNameController.clear();
      _confirmPasswordController.clear();
    });
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = null;
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _emailError = 'รูปแบบอีเมลไม่ถูกต้อง';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = null;
      } else if (value.length < 6) {
        _passwordError = 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
      } else {
        _passwordError = null;
      }

      // Also validate confirm password if it has content
      if (_mode == AuthMode.register &&
          _confirmPasswordController.text.isNotEmpty) {
        _validateConfirmPassword(_confirmPasswordController.text);
      }
    });
  }

  void _validateDisplayName(String value) {
    if (_mode == AuthMode.register) {
      setState(() {
        if (value.trim().isEmpty) {
          _displayNameError = 'กรุณากรอกชื่อแสดง';
        } else if (value.trim().length > 50) {
          _displayNameError = 'ชื่อแสดงต้องไม่เกิน 50 ตัวอักษร';
        } else {
          _displayNameError = null;
        }
      });
    }
  }

  void _validateConfirmPassword(String value) {
    if (_mode == AuthMode.register) {
      setState(() {
        if (value.isEmpty) {
          _confirmPasswordError = null;
        } else if (value != _passwordController.text) {
          _confirmPasswordError = 'รหัสผ่านไม่ตรงกัน';
        } else {
          _confirmPasswordError = null;
        }
      });
    }
  }

  Future<void> _submit() async {
    // Clear previous errors
    _clearErrors();

    // Validate form
    if (_mode == AuthMode.login) {
      if (_emailController.text.isEmpty) {
        setState(() => _emailError = 'กรุณากรอกอีเมล');
        return;
      }
      if (_passwordController.text.isEmpty) {
        setState(() => _passwordError = 'กรุณากรอกรหัสผ่าน');
        return;
      }

      await ref.read(authProvider.notifier).login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    } else {
      // Register mode
      if (_displayNameController.text.trim().isEmpty) {
        setState(() => _displayNameError = 'กรุณากรอกชื่อแสดง');
        return;
      }
      if (_emailController.text.isEmpty) {
        setState(() => _emailError = 'กรุณากรอกอีเมล');
        return;
      }
      if (_passwordController.text.isEmpty) {
        setState(() => _passwordError = 'กรุณากรอกรหัสผ่าน');
        return;
      }
      if (_confirmPasswordController.text.isEmpty) {
        setState(() => _confirmPasswordError = 'กรุณายืนยันรหัสผ่าน');
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() => _confirmPasswordError = 'รหัสผ่านไม่ตรงกัน');
        return;
      }
      if (_passwordController.text.length < 6) {
        setState(() => _passwordError = 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร');
        return;
      }

      await ref.read(authProvider.notifier).register(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            displayName: _displayNameController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    // Listen to auth state changes to handle errors
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        final error = next.errorMessage!;
        // Only show provider-level errors if field-level errors aren't set
        if (_emailError == null && _passwordError == null &&
            _displayNameError == null && _confirmPasswordError == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(_mode == AuthMode.login ? 'เข้าสู่ระบบ' : 'สมัครสมาชิก'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo/Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 40,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      _mode == AuthMode.login
                          ? 'ยินดีต้อนรับกลับ'
                          : 'สร้างบัญชีใหม่',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      _mode == AuthMode.login
                          ? 'กรอกอีเมลและรหัสผ่านเพื่อเข้าสู่ระบบ'
                          : 'กรอกข้อมูลเพื่อสร้างบัญชีใหม่',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Register Mode: Display Name
                    if (_mode == AuthMode.register) ...[
                      DisplayNameTextField(
                        controller: _displayNameController,
                        errorText: _displayNameError,
                        onChanged: _validateDisplayName,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Email Field
                    EmailTextField(
                      controller: _emailController,
                      errorText: _emailError,
                      onChanged: _validateEmail,
                      focusNode: _emailFocusNode,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    PasswordField(
                      controller: _passwordController,
                      errorText: _passwordError,
                      onChanged: _validatePassword,
                      focusNode: _passwordFocusNode,
                      textInputAction: _mode == AuthMode.register
                          ? TextInputAction.next
                          : TextInputAction.done,
                      onSubmitted: (_) {
                        if (_mode == AuthMode.register) {
                          FocusScope.of(context)
                              .requestFocus(_confirmPasswordFocusNode);
                        } else {
                          _submit();
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Register Mode: Confirm Password
                    if (_mode == AuthMode.register) ...[
                      PasswordField(
                        label: 'ยืนยันรหัสผ่าน',
                        controller: _confirmPasswordController,
                        errorText: _confirmPasswordError,
                        onChanged: _validateConfirmPassword,
                        focusNode: _confirmPasswordFocusNode,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Submit Button
                    LoadingButton(
                      text: _mode == AuthMode.login ? 'เข้าสู่ระบบ' : 'สมัครสมาชิก',
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 16),

                    // Toggle Mode Button
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          _mode == AuthMode.login
                              ? 'ยังไม่มีบัญชี?'
                              : 'มีบัญชีอยู่แล้ว?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        TextLoadingButton(
                          text: _mode == AuthMode.login
                              ? 'สมัครสมาชิก'
                              : 'เข้าสู่ระบบ',
                          onPressed: _toggleMode,
                          textColor: Colors.green,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'หรือ',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Back to Home Button
                    SecondaryLoadingButton(
                      text: 'กลับหน้าหลัก',
                      icon: Icons.home_outlined,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
