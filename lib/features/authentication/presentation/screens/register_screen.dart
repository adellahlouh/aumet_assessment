import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/core.export.dart';
import '../../../features.export.dart';

class RegisterScreen extends ConsumerWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ref) {
    final registerNotifier = ref.watch(registerUserNotifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Screen'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Register Screen',
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
              TextFieldWidget(
                controller: _fullNameController,
                hintText: 'Full name',
                validator: (str) => str!.length >= 10
                    ? null
                    : 'Full name must be length 10 or more ',
                icon: const Icon(Icons.person),
              ),
              const SizedBox(
                height: 32.0,
              ),
              TextFieldWidget(
                controller: _phoneController,
                hintText: 'Phone Number',
                validator: (str) => str!.length >= 10
                    ? null
                    : 'Phone number must be length 10.',
                icon: const Icon(Icons.call),
              ),
              const SizedBox(
                height: 32.0,
              ),
              btnWidget(
                title: 'Register',
                onTap: () => _onRegister(ref, context),
              ),
              registerNotifier.when(
                data: (data) {
                  return btnWidget(
                    title: 'Register',
                    onTap: () => _onRegister(ref, context),
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
                        title: 'Register',
                        onTap: () => _onRegister(ref, context),
                      ),
                    ],
                  );
                },
                loading: () {
                  return getCenterCircularProgress();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _onRegister(WidgetRef ref, BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    UserModel user = UserModel();
    user.email = _emailController.text;
    user.password = _passwordController.text;
    user.phone = int.parse(_phoneController.text);
    user.fullName = _fullNameController.text;

    final notifier = ref.read(registerUserNotifier.notifier);

    await notifier.register(user);

    notifier.addListener((state) {
      if (state.value != null) {
        openNewPage(context,  HomeScreen(), popPreviousPages: true);
      }
    });
  }
}
