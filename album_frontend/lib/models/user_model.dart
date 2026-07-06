class UserModel {
  final String userName;      // ایمیل یا شماره - یکتا - غیرقابل تغییر
  final String password;      // رمز عبور
  final String? displayName;  // اسم نمایشی - قابل تغییر
  final bool isBanned;
  final int photoCount;
  final int albumCount;

  UserModel({
    required this.userName,
    required this.password,
    this.displayName,
    this.isBanned = false,
    this.photoCount = 0,
    this.albumCount = 0,
  });

  // اسمی که نشون داده می‌شه
  String get displayNameOrUser => displayName ?? userName;

  // حرف اول برای آواتار
  String get avatarLetter => displayName != null 
      ? displayName![0].toUpperCase() 
      : userName[0].toUpperCase();
}