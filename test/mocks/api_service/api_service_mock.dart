// import 'package:admin/services/api_service.dart';
// import 'package:mockito/annotations.dart';
//
// @GenerateMocks([ApiService])
// void main() {}

import 'package:admin/services/api_service.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements TestApiService {}
