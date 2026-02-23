import 'dart:convert';

/// AuthUser model สำหรับระบบสมาชิก
/// เก็บข้อมูลผู้ใช้สำหรับการ Authentication
class AuthUser {
  final String id;
  final String email;
  final String password;
  final String displayName;
  final DateTime createdAt;
  final bool isActive;

  AuthUser({
    required this.id,
    required this.email,
    required this.password,
    required this.displayName,
    required this.createdAt,
    this.isActive = true,
  });

  /// สร้าง AuthUser จาก JSON
  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      displayName: json['displayName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// แปลง AuthUser เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'displayName': displayName,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  /// แปลงเป็น JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// สร้าง AuthUser จาก JSON string
  static AuthUser fromJsonString(String jsonString) {
    return AuthUser.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  /// สร้างสำเนาด้วยการแก้ไขบางฟิลด์
  AuthUser copyWith({
    String? id,
    String? email,
    String? password,
    String? displayName,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  /// ตรวจสอบความเท่ากัน
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthUser &&
        other.id == id &&
        other.email == email &&
        other.password == password &&
        other.displayName == displayName &&
        other.createdAt == createdAt &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      password,
      displayName,
      createdAt,
      isActive,
    );
  }

  @override
  String toString() {
    return 'AuthUser(id: $id, email: $email, displayName: $displayName, isActive: $isActive)';
  }

  /// สร้าง AuthUser ใหม่สำหรับการทดสอบ
  static AuthUser createTestUser({
    String? id,
    String? email,
    String? password,
    String? displayName,
  }) {
    return AuthUser(
      id: id ?? 'test-${DateTime.now().millisecondsSinceEpoch}',
      email: email ?? 'test@example.com',
      password: password ?? 'password123',
      displayName: displayName ?? 'Test User',
      createdAt: DateTime.now(),
    );
  }
}
