import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_testing_demo/services/api_service.dart';
import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ApiService', () {
    late MockClient mockClient;
    late ApiService apiService;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService(httpClient: mockClient);
    });

    group('fetchUser', () {
      test('should fetch user successfully', () async {
        when(mockClient.get(any)).thenAnswer((_) async =>
            http.Response(
              '{"id": 1, "name": "สมชาย", "email": "somchai@example.com", "isActive": true}',
              200,
            ));

        final user = await apiService.fetchUser(1);

        expect(user.id, equals(1));
        expect(user.name, equals('สมชาย'));
        expect(user.email, equals('somchai@example.com'));
        expect(user.isActive, isTrue);
      });

      test('should throw exception on 404 error', () async {
        when(mockClient.get(any))
            .thenAnswer((_) async => http.Response('Not found', 404));

        expect(
          () => apiService.fetchUser(999),
          throwsA(
            predicate<Exception>(
              (e) => e.toString().contains('ไม่พบผู้ใช้'),
            ),
          ),
        );
      });

      test('should throw exception on server error', () async {
        when(mockClient.get(any))
            .thenAnswer((_) async => http.Response('Server error', 500));

        expect(
          () => apiService.fetchUser(1),
          throwsA(isA<Exception>()),
        );
      });

      test('should call correct API endpoint', () async {
        when(mockClient.get(any)).thenAnswer((_) async =>
            http.Response(
              '{"id": 1, "name": "สมชาย", "email": "somchai@example.com", "isActive": true}',
              200,
            ));

        await apiService.fetchUser(1);

        verify(mockClient.get(Uri.parse('https://api.example.com/users/1')))
            .called(1);
      });
    });

    group('fetchAllUsers', () {
      test('should fetch all users successfully', () async {
        when(mockClient.get(any)).thenAnswer((_) async =>
            http.Response(
              '[{"id": 1, "name": "สมชาย", "email": "somchai@example.com", "isActive": true},'
              '{"id": 2, "name": "นางสาวสุนี", "email": "suni@example.com", "isActive": false}]',
              200,
            ));

        final users = await apiService.fetchAllUsers();

        expect(users.length, equals(2));
        expect(users[0].name, equals('สมชาย'));
        expect(users[1].name, equals('นางสาวสุนี'));
      });

      test('should throw exception on error', () async {
        when(mockClient.get(any))
            .thenAnswer((_) async => http.Response('Server error', 500));

        expect(
          () => apiService.fetchAllUsers(),
          throwsA(isA<Exception>()),
        );
      });

      test('should return empty list when no users', () async {
        when(mockClient.get(any))
            .thenAnswer((_) async => http.Response('[]', 200));

        final users = await apiService.fetchAllUsers();

        expect(users.length, equals(0));
      });
    });

    group('createUser', () {
      test('should create user successfully', () async {
        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async =>
            http.Response(
              '{"id": 3, "name": "ชาลี", "email": "chali@example.com", "isActive": true}',
              201,
            ));

        final user = await apiService.createUser('ชาลี', 'chali@example.com');

        expect(user.id, equals(3));
        expect(user.name, equals('ชาลี'));
        expect(user.email, equals('chali@example.com'));
      });

      test('should throw exception on creation failure', () async {
        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('Bad request', 400));

        expect(
          () => apiService.createUser('ชาลี', 'chali@example.com'),
          throwsA(
            predicate<Exception>(
              (e) => e.toString().contains('ไม่สามารถสร้างผู้ใช้ได้'),
            ),
          ),
        );
      });

      test('should post to correct endpoint with correct body', () async {
        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async =>
            http.Response(
              '{"id": 3, "name": "ชาลี", "email": "chali@example.com", "isActive": true}',
              201,
            ));

        await apiService.createUser('ชาลี', 'chali@example.com');

        verify(mockClient.post(
          Uri.parse('https://api.example.com/users'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).called(1);
      });
    });

    group('User Model', () {
      test('should convert user from JSON', () {
        final json = {
          'id': 1,
          'name': 'สมชาย',
          'email': 'somchai@example.com',
          'isActive': true,
        };

        final user = User.fromJson(json);

        expect(user.id, equals(1));
        expect(user.name, equals('สมชาย'));
        expect(user.email, equals('somchai@example.com'));
        expect(user.isActive, isTrue);
      });

      test('should convert user to JSON', () {
        final user = User(
          id: 1,
          name: 'สมชาย',
          email: 'somchai@example.com',
          isActive: true,
        );

        final json = user.toJson();

        expect(json['id'], equals(1));
        expect(json['name'], equals('สมชาย'));
        expect(json['email'], equals('somchai@example.com'));
        expect(json['isActive'], isTrue);
      });

      test('should handle missing isActive field', () {
        final json = {
          'id': 1,
          'name': 'สมชาย',
          'email': 'somchai@example.com',
        };

        final user = User.fromJson(json);

        expect(user.isActive, isTrue);
      });
    });
  });
}
