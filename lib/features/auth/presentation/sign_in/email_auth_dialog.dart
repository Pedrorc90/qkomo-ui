import 'package:flutter/material.dart';

import 'package:qkomo_ui/features/auth/presentation/sign_in/email_auth_form.dart';
import 'package:qkomo_ui/features/auth/presentation/sign_in/email_auth_result.dart';

part 'email_auth_dialog_state.dart';

class EmailAuthDialog extends StatefulWidget {
  const EmailAuthDialog({super.key});

  @override
  State<EmailAuthDialog> createState() => _EmailAuthDialogState();
}
