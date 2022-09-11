import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/core.export.dart';
import '../../../features.export.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ref) {
    final loginNotifier = ref.watch(loginUserNotifier);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login Screen',
                style: TextStyle(fontSize: 50.0),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFieldWidget(
                controller: _emailController,
                hintText: 'Email',
                validator: (str) =>
                    isValidEmail(str!) ? null : 'Please enter email valid',
                icon: const Icon(Icons.email),
              ),
              const SizedBox(
                height: 32.0,
              ),
              TextFieldWidget(
                controller: _passwordController,
                hintText: 'Password',
                validator: (str) => str!.length >= 6
                    ? null
                    : 'Password must be length 6 or more ',
                icon: const Icon(Icons.key),
              ),
              const SizedBox(
                height: 32.0,
              ),
              loginNotifier.when(
                data: (data) {
                  return btnWidget(
                    title: 'Login',
                    onTap: () => _onLogin(ref, context),
                  );
                },
                error: (e, s) {
                  return Column(
                    children: [
                      Text(
                        e.toString(),
                        style:
                            const TextStyle(fontSize: 30.0, color: Colors.red),
                      ),
                      btnWidget(
                        title: 'Login',
                        onTap: () => _onLogin(ref, context),
                      ),
                    ],
                  );
                },
                loading: () {
                  return getCenterCircularProgress();
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              btnWidget(title: 'Register', onTap: () => _onRegister(context)),
            ],
          ),
        ),
      ),
    );
  }

  Future _onLogin(WidgetRef ref, BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    UserModel user = UserModel();
    user.email = _emailController.text;
    user.password = _passwordController.text;

    final notifier = ref.read(loginUserNotifier.notifier);

    await notifier.login(user);

    notifier.addListener((state) {
      if (state.value != null) {
        final homeNotifier = ref.read(getUniversityNotifier.notifier) ;
        homeNotifier.getUniversitiesByType(ref.read(universityTypeProvider.notifier).state);
        openNewPage(context,  HomeScreen(), popPreviousPages: true);
      }
    });
  }

  void _onRegister(BuildContext context) {
    openNewPage(context, RegisterScreen());
  }
}
