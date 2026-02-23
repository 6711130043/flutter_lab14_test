import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_user.dart';

/// Exception สำหรับ Auth errors
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

/// AuthService สำหรับจัดการ Authentication และ User data
/// ใช้ SharedPreferences สำหรับเก็บข้อมูล Local
class AuthService {
  static const String _currentUserKey = 'auth_current_user';
  static const String _usersPrefixKey = 'auth_user_';

  final SharedPreferences prefs;

  AuthService({required this.prefs});

  /// สร้าง instance จาก SharedPreferences
  static Future<AuthService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AuthService(prefs: prefs);
  }

  /// ตรวจสอบรูปแบบอีเมล (พื้นฐาน)
  bool validateEmail(String email) {
    if (email.isEmpty) return false;
    // ตรวจสอบรูปแบบพื้นฐาน: ต้องมี @ และ domain
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// ตรวจสอบรูปแบบรหัสผ่าน (ต้องมี 6+ ตัวอักษร และมีตัวหนังสือและตัวเลขผสม)
  bool validatePassword(String password) {
    if (password.length < 6) return false;
    // ต้องมีตัวหนังสือ
    final hasLetters = password.contains(RegExp(r'[a-zA-Z]'));
    // ต้องมีตัวเลข
    final hasNumbers = password.contains(RegExp(r'[0-9]'));
    return hasLetters && hasNumbers;
  }

  /// ตรวจสอบชื่อแสดง (ไม่ว่างเปล่า และไม่เกิน 50 ตัวอักษร)
  bool validateDisplayName(String displayName) {
    return displayName.trim().isNotEmpty && displayName.trim().length <= 50;
  }

  /// ตรวจสอบว่าอีเมลมีการใช้งานแล้วหรือไม่
  Future<bool> _isEmailTaken(String email) async {
    final usersData = prefs.getString('auth_users_list') ?? '[]';
    final List<dynamic> usersList = jsonDecode(usersData) as List<dynamic>;

    for (final userEmail in usersList) {
      if (userEmail == email) return true;
    }
    return false;
  }

  /// เพิ่มอีเมลเข้ารายการผู้ใช้
  Future<void> _addEmailToList(String email) async {
    final usersData = prefs.getString('auth_users_list') ?? '[]';
    final List<dynamic> usersList = jsonDecode(usersData) as List<dynamic>;

    usersList.add(email);
    await prefs.setString('auth_users_list', jsonEncode(usersList));
  }

  /// สมัครสมาชิกใหม่
  /// คืนค่า true ถ้าสำเร็จ, โยน AuthException ถ้าไม่สำเร็จ
  Future<AuthUser> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    // Validate email
    if (!validateEmail(email)) {
      throw AuthException('รูปแบบอีเมลไม่ถูกต้อง');
    }

    // Validate password
    if (!validatePassword(password)) {
      throw AuthException('รหัสผ่านต้องมีตัวหนังสือและตัวเลขผสม (อย่างน้อย 6 ตัวอักษร)');
    }

    // Validate display name
    if (!validateDisplayName(displayName)) {
      throw AuthException('ชื่อแสดงต้องไม่ว่างเปล่าและไม่เกิน 50 ตัวอักษร');
    }

    // ตรวจสอบว่าอีเมลซ้ำหรือไม่
    if (await _isEmailTaken(email)) {
      throw AuthException('อีเมลนี้ถูกใช้งานแล้ว');
    }

    // สร้าง user ใหม่
    final user = AuthUser(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      password: password, // ใน production ควรใช้ hashing
      displayName: displayName.trim(),
      createdAt: DateTime.now(),
    );

    // บันทึกข้อมูล user
    final userKey = '$_usersPrefixKey${user.id}';
    await prefs.setString(userKey, user.toJsonString());

    // เพิ่มอีเมลเข้ารายการ
    await _addEmailToList(email);

    // บันทึกเป็น current user
    await prefs.setString(_currentUserKey, user.toJsonString());

    return user;
  }

  /// เข้าสู่ระบบ
  /// คืนค่า user ถ้าสำเร็จ, โยน AuthException ถ้าไม่สำเร็จ
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    // Validate email
    if (!validateEmail(email)) {
      throw AuthException('รูปแบบอีเมลไม่ถูกต้อง');
    }

    // Validate password
    if (password.isEmpty) {
      throw AuthException('กรุณากรอกรหัสผ่าน');
    }

    // ค้นหา user จากอีเมล
    AuthUser? foundUser;
    final usersData = prefs.getString('auth_users_list') ?? '[]';
    final List<dynamic> usersList = jsonDecode(usersData) as List<dynamic>;

    for (final userEmail in usersList) {
      if (userEmail == email) {
        // หา user ที่มีอีเมลตรงกัน
        final keys = prefs.getKeys().where((key) =>
          key.startsWith(_usersPrefixKey));

        for (final key in keys) {
          final userData = prefs.getString(key);
          if (userData != null) {
            try {
              final user = AuthUser.fromJsonString(userData);
              if (user.email == email) {
                foundUser = user;
                break;
              }
            } catch (e) {
              // Skip invalid data
              continue;
            }
          }
        }
        break;
      }
    }

    if (foundUser == null) {
      throw AuthException('ไม่พบอีเมลนี้ในระบบ');
    }

    // ตรวจสอบรหัสผ่าน
    if (foundUser.password != password) {
      throw AuthException('รหัสผ่านไม่ถูกต้อง');
    }

    // ตรวจสอบสถานะการใช้งาน
    if (!foundUser.isActive) {
      throw AuthException('บัญชีนี้ถูกระงับการใช้งาน');
    }

    // บันทึกเป็น current user
    await prefs.setString(_currentUserKey, foundUser.toJsonString());

    return foundUser;
  }

  /// ออกจากระบบ
  Future<void> logout() async {
    await prefs.remove(_currentUserKey);
  }

  /// ดึงข้อมูลผู้ใช้ที่ login อยู่
  /// คืนค่า null ถ้ายังไม่ได้ login
  Future<AuthUser?> getCurrentUser() async {
    final userData = prefs.getString(_currentUserKey);
    if (userData == null) return null;

    try {
      return AuthUser.fromJsonString(userData);
    } catch (e) {
      // ถ้าข้อมูลเสียหาย ให้ลบออก
      await prefs.remove(_currentUserKey);
      return null;
    }
  }

  /// ตรวจสอบว่ามีผู้ใช้ login อยู่หรือไม่
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  /// ลบข้อมูลผู้ใช้ทั้งหมด (สำหรับการทดสอบ)
  Future<void> clearAllUsers() async {
    final usersData = prefs.getString('auth_users_list') ?? '[]';
    final List<dynamic> usersList = jsonDecode(usersData) as List<dynamic>;

    // ลบข้อมูล user ทั้งหมด
    for (final userEmail in usersList) {
      final keys = prefs.getKeys().where((key) =>
        key.startsWith(_usersPrefixKey));

      for (final key in keys) {
        await prefs.remove(key);
      }
    }

    // ลบรายการอีเมล
    await prefs.remove('auth_users_list');

    // ลบ current user
    await prefs.remove(_currentUserKey);
  }

  /// ดึงข้อมูลผู้ใช้ทั้งหมด (สำหรับการทดสอบ)
  Future<List<AuthUser>> getAllUsers() async {
    final usersData = prefs.getString('auth_users_list') ?? '[]';
    final List<dynamic> usersList = jsonDecode(usersData) as List<dynamic>;
    final List<AuthUser> users = [];

    for (final userEmail in usersList) {
      final keys = prefs.getKeys().where((key) =>
        key.startsWith(_usersPrefixKey));

      for (final key in keys) {
        final userData = prefs.getString(key);
        if (userData != null) {
          try {
            final user = AuthUser.fromJsonString(userData);
            if (user.email == userEmail && !users.any((u) => u.id == user.id)) {
              users.add(user);
            }
          } catch (e) {
            // Skip invalid data
            continue;
          }
        }
      }
    }

    return users;
  }

  /// อัปเดตข้อมูลผู้ใช้
  Future<AuthUser> updateUser(AuthUser updatedUser) async {
    final currentUser = await getCurrentUser();
    if (currentUser == null) {
      throw AuthException('ยังไม่ได้เข้าสู่ระบบ');
    }

    final userKey = '$_usersPrefixKey${updatedUser.id}';
    await prefs.setString(userKey, updatedUser.toJsonString());

    // อัปเดต current user ถ้าเป็น user เดียวกัน
    if (currentUser.id == updatedUser.id) {
      await prefs.setString(_currentUserKey, updatedUser.toJsonString());
    }

    return updatedUser;
  }
}
