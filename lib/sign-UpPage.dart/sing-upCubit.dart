// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

enum RegistrationState { initial, loading, success, failure }

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationState.initial);

  Future<void> register({
    required String name,
    required String lastName,
    required String address,
    required String email,
    required String password,
    required String nationalId,
  }) async {
    try {
      emit(RegistrationState.loading);

      final response = await http.post(
        Uri.parse('https://haidarjaded787.serv00.net/api/clients'),
        body: {
          'name': name,
          'lastName': lastName,
          'address': address,
          'email': email,
          'password': password,
          'nationalId': nationalId,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        emit(RegistrationState.success);
        print('User registered successfully: $data');
      } else {
        emit(RegistrationState.failure);
        print('Registration failed: ${data['error']}');
      }
    } catch (e) {
      emit(RegistrationState.failure);
      print('Error during registration: $e');
    }
  }
}
