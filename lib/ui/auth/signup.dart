import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/ui/auth/login.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../constant/appimages.dart';
import '../../constant/snackbar.dart';
import '../../constant/validator.dart';
import '../../widgets/border_textfield.dart';
import '../../widgets/hspace.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/vspace.dart';
import '../home/home.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
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
              } else if (state is SignupSuccessState) {
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
                    AppImages.signupGif,
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
                VSpace(20),
                BorderedTextFormField(
                  hintText: "UserName",
                  controller: _userNameController,
                  validator: (value) => Validator.validateUsername(value),
                ),
                VSpace(10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Already have an account?",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey)),
                      HSpace(10),
                      Text(
                        "Log In",
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
                    text: "Sign Up",
                    onTap: () {
                      _signUp();
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

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        context.read<AuthBloc>().add(SignupEvent(
              email: _emailController.text,
              password: _passwordController.text,
              username: _userNameController.text,
            ));
      } catch (e) {
        print(e);
      }
    }
  }
}
