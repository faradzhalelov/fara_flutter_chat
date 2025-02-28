// lib/features/auth/presentation/view/components/forgot_password_dialog.dart
import 'package:fara_chat/app/theme/icons.dart';
import 'package:fara_chat/app/theme/text_styles.dart';
import 'package:fara_chat/core/utils/validators/validators.dart';
import 'package:fara_chat/presentation/auth/view/components/auth_widgets.dart';
import 'package:fara_chat/presentation/auth/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ForgotPasswordDialog extends ConsumerStatefulWidget {

  const ForgotPasswordDialog({
    required this.onSubmit, 
    required this.onSuccess, 
    super.key,
  });
  final void Function(String) onSubmit;
  final VoidCallback onSuccess;

  @override
  ConsumerState<ForgotPasswordDialog> createState() =>
      _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends ConsumerState<ForgotPasswordDialog> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);

    // Show success message and close dialog
    if (state.passwordResetSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Инструкции по сбросу пароля отправлены на ваш email'),
            backgroundColor: Colors.green,
          ),
        );

        widget.onSuccess();
      });
    }

    // Show error if exists
    if (state.passwordResetError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.passwordResetError!),
            backgroundColor: Colors.red,
          ),
        );

        widget.onSuccess();
      });
    }

    return AlertDialog(
      title: const Text('Сброс пароля'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text(
              'Введите ваш email для получения инструкций по сбросу пароля',
              style: AppTextStyles.smallSemiBold,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: emailController,
              labelText: 'Email',
              hintText: 'Введите ваш email',
              prefixIcon: Icomoon.mail,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
              enabled: !state.isPasswordResetLoading,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: state.isPasswordResetLoading
              ? null
              : () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: state.isPasswordResetLoading ? null : _handleSubmit,
          child: state.isPasswordResetLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('Отправить'),
        ),
      ],
    );
  }

  void _handleSubmit() {
    if (formKey.currentState!.validate()) {
      widget.onSubmit(emailController.text.trim());
    }
  }
}
