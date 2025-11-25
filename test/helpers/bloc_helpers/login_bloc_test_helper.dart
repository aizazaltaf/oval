import 'package:admin/models/states/api_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/bloc/bloc_mocks.dart';
import '../../mocks/bloc/state_mocks.dart';

class LoginBlocTestHelper {
  late MockLoginBloc mockLoginBloc;
  late MockLoginState currentLoginState;

  void setup() {
    mockLoginBloc = MockLoginBloc();
    currentLoginState = MockLoginState();

    when(() => mockLoginBloc.stream).thenAnswer((_) => Stream.value(currentLoginState));
    when(() => mockLoginBloc.state).thenReturn(currentLoginState);

    setupDefaultState();
    setupMethodMocks();
  }

  void setupDefaultState() {
    // Stub all properties that your UI or logic might access
    when(() => currentLoginState.logoutApi).thenReturn(ApiState<void>());
    when(() => currentLoginState.loginApi).thenReturn(ApiState<void>());
    when(() => currentLoginState.resendApi).thenReturn(ApiState<void>());
    when(() => currentLoginState.signUpApi).thenReturn(ApiState<void>());
    when(() => currentLoginState.otpApi).thenReturn(ApiState<void>());
    when(() => currentLoginState.forgetPasswordApi)
        .thenReturn(ApiState<void>());
    when(() => currentLoginState.validateEmailApi).thenReturn(ApiState<void>());
    // Add more stubs as needed for your tests
  }

  void setupMethodMocks() {
    // Add method stubs if your tests call any LoginBloc methods
    when(
      () => mockLoginBloc.callLogout(
        successFunction: any(named: 'successFunction'),
      ),
    ).thenAnswer((_) async {});
    when(() => mockLoginBloc.callLogin(any())).thenAnswer((_) async {});
    when(() => mockLoginBloc.callResendEmail()).thenAnswer((_) async {});
    when(
      () => mockLoginBloc.callValidateEmail(
        successFunction: any(named: 'successFunction'),
      ),
    ).thenAnswer((_) async {});
    when(() => mockLoginBloc.callSignup()).thenAnswer((_) async {});
    when(() => mockLoginBloc.callOtp(any())).thenAnswer((_) async {});
    when(
      () => mockLoginBloc.callForgotPassword(
        successFunction: any(named: 'successFunction'),
      ),
    ).thenAnswer((_) async {});
  }
}
