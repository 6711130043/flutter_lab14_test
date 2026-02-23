import 'package:http/http.dart' as http;
import 'dart:convert';

/// Mock user data for API service
class User {
  final int id;
  final String name;
  final String email;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'isActive': isActive,
      };
}

/// API Service for fetching user data
class ApiService {
  final http.Client httpClient;
  static const String baseUrl = 'https://api.example.com';

  ApiService({http.Client? httpClient}) : httpClient = httpClient ?? http.Client();

  /// Fetch a user by ID
  Future<User> fetchUser(int userId) async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl/users/$userId'),
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else if (response.statusCode == 404) {
      throw Exception('ไม่พบผู้ใช้');
    } else {
      throw Exception('ข้อผิดพลาด: ${response.statusCode}');
    }
  }

  /// Fetch all users
  Future<List<User>> fetchAllUsers() async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl/users'),
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data
          .map((user) => User.fromJson(user as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('ข้อผิดพลาด: ${response.statusCode}');
    }
  }

  /// Create a new user
  Future<User> createUser(String name, String email) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email, 'isActive': true}),
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('ไม่สามารถสร้างผู้ใช้ได้');
    }
  }
}
