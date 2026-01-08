import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<User>(),
  MockSpec<Connectivity>(),
  MockSpec<ImagePicker>(),
  MockSpec<Dio>(),
])
void main() {}
