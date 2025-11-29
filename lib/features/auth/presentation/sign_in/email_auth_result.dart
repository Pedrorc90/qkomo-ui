class EmailAuthResult {
  const EmailAuthResult({
    required this.email,
    required this.password,
    required this.mode,
  });

  final String email;
  final String password;
  final EmailAuthMode mode;
}

enum EmailAuthMode { signIn, register }
