import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/constant/appimages.dart';
import 'package:ispy/constant/snackbar.dart';
import 'package:ispy/constant/validator.dart';
import 'package:ispy/ui/auth/signup.dart';
import 'package:ispy/widgets/border_textfield.dart';
import 'package:ispy/widgets/hspace.dart';
import 'package:ispy/widgets/vspace.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../widgets/primary_button.dart';
import '../home/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoadingState) {
                showOverlayLoader(context);
              } else if (state is LoginSuccessState) {
                hideOverlayLoader(context);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              } else if (state is AuthErrorState) {
                hideOverlayLoader(context);
                showErrorSnackbar(context, state.message);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    AppImages.loginGif,
                  ),
                ),
                VSpace(20),
                BorderedTextFormField(
                  hintText: "Email",
                  controller: _emailController,
                  validator: (value) => Validator.validateEmail(value),
                ),
                VSpace(20),
                BorderedTextFormField(
                  hintText: "Password",
                  controller: _passwordController,
                  validator: (value) => Validator.validatePassword(value),
                ),
                VSpace(10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Don't have an account?",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey)),
                      HSpace(10),
                      Text(
                        "Sign up",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
                Expanded(child: VSpace(0)),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: "Login",
                    onTap: () {
                      _login();
                    },
                  ),
                ),
                VSpace(20)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        context.read<AuthBloc>().add(LoginEvent(
              email: _emailController.text,
              password: _passwordController.text,
            ));
      } catch (e) {
        print(e);
      }
    }
  }
}
