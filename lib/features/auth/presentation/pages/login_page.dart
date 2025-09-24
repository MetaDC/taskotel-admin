import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskoteladmin/core/routes/routes.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskoteladmin/features/auth/presentation/widgets/auth_textfileds.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.message != null && state.message!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor:
                  state.message!.contains('success') ||
                      state.message!.contains('sent')
                  ? Colors.green
                  : Colors.red,
            ),
          );
        }
        if (state.isAuthenticated) {
          context.go(Routes.dashboard);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Form(
            key: authCubit.loginFormKey,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.containerGreyColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.slateGray),
                ),
                constraints: const BoxConstraints(
                  maxWidth: 600,
                  maxHeight: 720,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: const BoxDecoration(
                        color: AppColors.slateGray,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Image.asset("assets/logos/logo.png"),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Welcome back",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 30),
                    AuthTextField(
                      controller: authCubit.emailController,
                      hintText: "Email",
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      controller: authCubit.passwordController,
                      hintText: "Password",
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),

                    // Forgot password
                    InkWell(
                      onTap: () {
                        context.read<AuthCubit>().forgetPassword(
                          authCubit.emailController.text,
                        );
                      },
                      child: Container(
                        width: 430,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Forgot password?",
                          style: AppTextStyles.hintText.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.slateGray,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 430,
                      child: PrimaryButton(
                        isLoading: state.isLoading,
                        text: "Login",
                        onPressed: () {
                          authCubit.login(
                            authCubit.emailController.text,
                            authCubit.passwordController.text,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 100),

                    Text.rich(
                      TextSpan(
                        text: "Developed by ",
                        style: TextStyle(
                          color: AppColors.slateGray,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: "Diwizon",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            // recognizer: TapGestureRecognizer()
                            //   ..onTap = () {
                            //     // Use the url_launcher package
                            //     launchUrl(Uri.parse("https://diwizon.com"));
                            //   },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
