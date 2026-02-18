import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidak_desa_mobile/core/const/app_colors.dart';
import 'package:sidak_desa_mobile/core/widgets/app_button.dart';
import 'package:sidak_desa_mobile/core/widgets/app_textfield.dart';
import 'package:sidak_desa_mobile/core/widgets/app_textfield_password.dart';
import 'package:sidak_desa_mobile/presentation/controllers/login_controller.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(width: 200, 'assets/images/logo.png'),
            const SizedBox(height: 20),
            Image.asset(width: 200, 'assets/images/ilustrasi.png'),
            const SizedBox(height: 20),
            Text(
              "Login",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            Align(alignment: Alignment.centerLeft, child: Text("Email")),
            const SizedBox(height: 10),
            AppTextField(
              hintText: "Email",
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 20),

            Align(alignment: Alignment.centerLeft, child: Text("Password")),
            const SizedBox(height: 10),
            AppTextFieldPassword(
              hintText: "Password",
              controller: passwordController,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20),
            Obx(
              () => controller.isLoading.value
                  ? const CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    )
                  : AppButton(
                      text: "Masuk",
                      onPressed: () {
                        controller.login(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
