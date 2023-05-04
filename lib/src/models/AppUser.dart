class AppUser {
  const AppUser({
    required this.name,
    this.email,
    required this.admin,
  });
  final String name;
  final String? email;
  final bool admin;
}