import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_user.dart';
import '../services/auth_service.dart';

/// สถานะของ Authentication
enum AuthStatus {
  initial,        // เริ่มต้น
  authenticated,  // ล็อกอินแล้ว
  unauthenticated, // ยังไม่ได้ล็อกอิน
  loading,        // กำลังโหลด
  error,          // เกิดข้อผิดพลาด
}

/// AuthState เก็บสถานะปัจจุบันของ Authentication
class AuthState {
  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  /// สร้าง state เริ่มต้น
  const AuthState.initial()
      : status = AuthStatus.initial,
        user = null,
        errorMessage = null;

  /// สร้าง state ขณะโหลด
  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        errorMessage = null;

  /// สร้าง state สำหรับ authenticated
  AuthState.authenticated(AuthUser user)
      : status = AuthStatus.authenticated,
        user = user,
        errorMessage = null;

  /// สร้าง state สำหรับ unauthenticated
  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        errorMessage = null;

  /// สร้าง state สำหรับ error
  const AuthState.error(String message)
      : status = AuthStatus.error,
        user = null,
        errorMessage = message;

  /// สร้างสำเนา state
  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// ตรวจสอบว่า authenticated หรือไม่
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// ตรวจสอบว่ากำลังโหลดหรือไม่
  bool get isLoading => status == AuthStatus.loading;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.status == status &&
        other.user == user &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(status, user, errorMessage);

  @override
  String toString() =>
      'AuthState(status: $status, user: $user, errorMessage: $errorMessage)';
}

/// AuthNotifier จัดการ state ของ Authentication
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState.initial()) {
    _checkAuthStatus();
  }

  /// ตรวจสอบสถานะการล็อกอินเมื่อเริ่มต้น
  Future<void> _checkAuthStatus() async {
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  /// สมัครสมาชิก
  Future<bool> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AuthState.loading();

    try {
      final user = await _authService.register(
        email: email,
        password: password,
        displayName: displayName,
      );

      state = AuthState.authenticated(user);
      return true;
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
      return false;
    } catch (e) {
      state = AuthState.error('เกิดข้อผิดพลาด: ${e.toString()}');
      return false;
    }
  }

  /// เข้าสู่ระบบ
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    try {
      final user = await _authService.login(
        email: email,
        password: password,
      );

      state = AuthState.authenticated(user);
      return true;
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
      return false;
    } catch (e) {
      state = AuthState.error('เกิดข้อผิดพลาด: ${e.toString()}');
      return false;
    }
  }

  /// ออกจากระบบ
  Future<void> logout() async {
    state = const AuthState.loading();

    try {
      await _authService.logout();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  /// อัปเดตข้อมูลผู้ใช้
  Future<bool> updateUser(AuthUser updatedUser) async {
    try {
      final user = await _authService.updateUser(updatedUser);
      state = AuthState.authenticated(user);
      return true;
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
      return false;
    } catch (e) {
      state = AuthState.error('เกิดข้อผิดพลาด: ${e.toString()}');
      return false;
    }
  }

  /// ล้าง error message
  void clearError() {
    if (state.status == AuthStatus.error) {
      if (state.user != null) {
        state = AuthState.authenticated(state.user!);
      } else {
        state = const AuthState.unauthenticated();
      }
    }
  }

  /// โหลดข้อมูล user ปัจจุบันใหม่
  Future<void> refreshUser() async {
    await _checkAuthStatus();
  }
}

/// Provider สำหรับ AuthService (ใช้สำหรับ DI)
final authServiceProvider = Provider<AuthService>((ref) {
  throw UnimplementedError('AuthService must be initialized in main()');
});

/// Provider สำหรับ AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

/// Provider สำหรับตรวจสอบว่า user ล็อกอินหรือยัง
final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isAuthenticated;
});

/// Provider สำหรับดึงข้อมูล user ปัจจุบัน
final currentUserProvider = Provider<AuthUser?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
});
