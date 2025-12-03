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
    final scheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: scheme.surface,
      surfaceTintColor: scheme.surfaceTint,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  tooltip: 'Cerrar',
                ),
              ],
            ),
            const SizedBox(height: 24),
            EmailAuthForm(
              emailController: _emailController,
              passwordController: _passwordController,
              mode: _mode,
              onToggleMode: _toggleMode,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => _submit(context),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                _mode == EmailAuthMode.signIn
                    ? 'Iniciar sesión'
                    : 'Crear cuenta',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _title =>
      _mode == EmailAuthMode.signIn ? 'Bienvenido de nuevo' : 'Únete a qkomo';

  void _toggleMode() {
    setState(() {
      _mode = _mode == EmailAuthMode.signIn
          ? EmailAuthMode.register
          : EmailAuthMode.signIn;
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
