import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/profile/application/companion_controller.dart';

class AddCompanionDialog extends ConsumerStatefulWidget {
  const AddCompanionDialog({super.key});

  @override
  ConsumerState<AddCompanionDialog> createState() => _AddCompanionDialogState();
}

class _AddCompanionDialogState extends ConsumerState<AddCompanionDialog> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Close dialog immediately to avoid blocking UI, controller handles state
    // Ideally we wait for success but for this simple flow we can close
    final navigator = Navigator.of(context);
    final email = _emailController.text.trim();

    await ref.read(companionControllerProvider.notifier).inviteCompanion(email);

    // Check if mounted and no error in state (optimistic)
    // In a real app we might want to show error snackbar if it failed
    if (mounted) {
      ref.invalidate(companionListProvider);
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(companionControllerProvider);
    final isLoading = state.isLoading;

    ref.listen(companionControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );
      }
    });

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Añadir Compañero',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Introduce el email de tu compañero para compartir el menú semanal.',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce un email';
                      }
                      if (!value.contains('@')) {
                        return 'Introduce un email válido';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      isLoading ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Invitar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
