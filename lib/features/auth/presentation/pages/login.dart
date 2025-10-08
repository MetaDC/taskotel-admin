// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:taskoteladmin/core/routes/routes.dart';
// import 'package:taskoteladmin/core/theme/app_colors.dart';
// import 'package:taskoteladmin/core/theme/app_text_styles.dart';
// import 'package:taskoteladmin/features/auth/presentation/cubit/auth_cubit.dart';
// import 'package:taskoteladmin/features/auth/presentation/widgets/auth_textfileds.dart';
// import 'package:url_launcher/url_launcher.dart';

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   void _handleLogin(AuthCubit authCubit) {
//     authCubit.login(
//       authCubit.emailController.text,
//       authCubit.passwordController.text,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authCubit = context.read<AuthCubit>();

//     return BlocConsumer<AuthCubit, AuthState>(
//       listener: (context, state) {
//         if (state.message != null && state.message!.isNotEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.message!),
//               backgroundColor:
//                   state.message!.contains('success') ||
//                       state.message!.contains('sent')
//                   ? Colors.green
//                   : Colors.red,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           );
//         }
//         if (state.isAuthenticated) {
//           context.go(Routes.dashboard);
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           body: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   AppColors.primary.withValues(alpha: 0.05),
//                   AppColors.slateGray.withValues(alpha: 0.05),
//                 ],
//               ),
//             ),
//             child: Form(
//               key: authCubit.loginFormKey,
//               child: Center(
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(24),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withValues(alpha: 0.08),
//                             blurRadius: 30,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       constraints: const BoxConstraints(maxWidth: 480),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // Header Section
//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.all(48),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                                 colors: [
//                                   AppColors.primary,
//                                   AppColors.primary.withValues(alpha: 0.8),
//                                 ],
//                               ),
//                               borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(24),
//                                 topRight: Radius.circular(24),
//                               ),
//                             ),
//                             child: Column(
//                               children: [
//                                 Image.asset(
//                                   "assets/logos/logo.png",
//                                   height: 60,
//                                 ),
//                                 const SizedBox(height: 24),
//                                 Text(
//                                   "Welcome Back",
//                                   style: GoogleFonts.inter(
//                                     fontSize: 28,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                     letterSpacing: -0.5,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   "Sign in to continue to your dashboard",
//                                   style: GoogleFonts.inter(
//                                     fontSize: 14,
//                                     color: Colors.white.withValues(alpha: 0.8),
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                           // Form Section
//                           Padding(
//                             padding: const EdgeInsets.all(40.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Email Field
//                                 Text(
//                                   "Email Address",
//                                   style: GoogleFonts.inter(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     color: AppColors.slateGray,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 AuthTextField(
//                                   controller: authCubit.emailController,
//                                   hintText: "Enter your email",
//                                   obscureText: false,
//                                 ),
//                                 const SizedBox(height: 20),

//                                 // Password Field
//                                 Text(
//                                   "Password",
//                                   style: GoogleFonts.inter(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     color: AppColors.slateGray,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 AuthTextField(
//                                   controller: authCubit.passwordController,
//                                   hintText: "Enter your password",
//                                   obscureText: true,
//                                 ),
//                                 const SizedBox(height: 16),

//                                 // Forgot Password
//                                 Align(
//                                   alignment: Alignment.centerRight,
//                                   child: InkWell(
//                                     onTap: () {
//                                       context.read<AuthCubit>().forgetPassword(
//                                         authCubit.emailController.text,
//                                       );
//                                     },
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 8,
//                                         vertical: 4,
//                                       ),
//                                       child: Text(
//                                         "Forgot password?",
//                                         style: GoogleFonts.inter(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.primary,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 32),

//                                 // Login Button
//                                 SizedBox(
//                                   width: double.infinity,
//                                   child: PrimaryButton(
//                                     isLoading: state.isLoading,
//                                     text: "Sign In",
//                                     onPressed: () => _handleLogin(authCubit),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 24),

//                                 // Divider
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Divider(
//                                         color: AppColors.slateGray.withValues(
//                                           alpha: 0.2,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 16,
//                                       ),
//                                       child: Text(
//                                         "Developed by",
//                                         style: GoogleFonts.inter(
//                                           fontSize: 12,
//                                           color: AppColors.slateGray.withValues(
//                                             alpha: 0.5,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Divider(
//                                         color: AppColors.slateGray.withValues(
//                                           alpha: 0.2,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 24),

//                                 // Footer
//                                 Center(
//                                   child: MouseRegion(
//                                     cursor: SystemMouseCursors.click,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         launchUrl(
//                                           Uri.parse("https://diwizon.com"),
//                                         );
//                                       },
//                                       child: Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 20,
//                                           vertical: 10,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: AppColors.primary.withValues(
//                                             alpha: 0.1,
//                                           ),
//                                           borderRadius: BorderRadius.circular(
//                                             20,
//                                           ),
//                                         ),
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Icon(
//                                               Icons.auto_awesome,
//                                               size: 16,
//                                               color: AppColors.primary,
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Text(
//                                               "Diwizon",
//                                               style: GoogleFonts.inter(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: AppColors.primary,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
