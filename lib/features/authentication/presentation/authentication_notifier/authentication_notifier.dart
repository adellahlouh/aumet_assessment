import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data.export.dart';

/// Login Notifier
final loginUserNotifier = StateNotifierProvider<LoginUserStateNotifier, AsyncValue<UserModel?>>((ref) {
  return LoginUserStateNotifier();
});

class LoginUserStateNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  LoginUserStateNotifier() : super(const AsyncData(null));

  Future login(UserModel user) async {
    try {
      UserModel userModel = UserModel();
      state = const AsyncLoading();
      userModel = (await AuthRepositoriesImpl().loginByEmail(user));
      state = AsyncValue.data(userModel);
    }catch (e){
      state = AsyncError(e);
    }
  }
}

/// Register Notifier
final registerUserNotifier = StateNotifierProvider<RegisterUserStateNotifier, AsyncValue<UserModel?>>((ref) {
  return RegisterUserStateNotifier();
});

class RegisterUserStateNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  RegisterUserStateNotifier() : super(const AsyncData(null));

  Future register(UserModel user) async {
    try {
      UserModel userModel = UserModel();
      state = const AsyncLoading();
      userModel = (await AuthRepositoriesImpl().registerUser(user));
      state = AsyncValue.data(userModel);
    }catch (e){
      state = AsyncValue.error(e);
    }
  }
}
