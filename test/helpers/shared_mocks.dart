import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mockito/annotations.dart';
import 'package:qkomo_ui/features/capture/data/capture_api_client.dart';

@GenerateNiceMocks([
  MockSpec<User>(),
  MockSpec<Connectivity>(),
  MockSpec<CaptureApiClient>(),
])
void main() {}
