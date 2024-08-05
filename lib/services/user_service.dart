import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserService {
  static const String baseUrl = 'https://reqres.in/api';
  static Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users?page=2'));
      final body = response.body;
      final result = jsonDecode(body);
      List<User> users = List<User>.from(
        result['data'].map(
          (user) => User.fromJson(user),
        ),
      );
      return users;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}