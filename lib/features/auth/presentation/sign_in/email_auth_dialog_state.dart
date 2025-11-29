part of 'email_auth_dialog.dart';

class _EmailAuthDialogState extends State<EmailAuthDialog> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  EmailAuthMode _mode = EmailAuthMode.signIn;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: EmailAuthForm(
        emailController: _emailController,
        passwordController: _passwordController,
        mode: _mode,
        onToggleMode: _toggleMode,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => _submit(context),
          child: Text(_mode == EmailAuthMode.signIn ? 'Iniciar sesión' : 'Registrar'),
        )
      ],
    );
  }

  String get _title => _mode == EmailAuthMode.signIn ? 'Inicia sesión con email' : 'Crea tu cuenta';

  void _toggleMode() {
    setState(() {
      _mode = _mode == EmailAuthMode.signIn ? EmailAuthMode.register : EmailAuthMode.signIn;
    });
  }

  void _submit(BuildContext context) {
    Navigator.of(context).pop(
      EmailAuthResult(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        mode: _mode,
      ),
    );
  }
}
