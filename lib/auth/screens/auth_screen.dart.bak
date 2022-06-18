import 'package:alexandrya/auth/controllers/auth_controller.dart';
import 'package:alexandrya/helpers/loading/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController emailCtr = TextEditingController();
  final TextEditingController passwordCtr = TextEditingController();
  FormType _formType = FormType.login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _formType == FormType.login
            ? Text('login'.tr)
            : Text('register'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: _formType == FormType.login ? loginForm() : registerForm(),
      ),
    );
  }

  Form loginForm() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextFormField(
          controller: emailCtr..text = "george.bluth@reqres.in",
          decoration: inputDecoration('E-mail', Icons.person),
          validator: (value) {
            return (value == null || value.isEmpty) ? 'enter_email'.tr : null;
          },
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: passwordCtr..text = "123456",
          decoration: inputDecoration('password'.tr, Icons.lock),
          validator: (value) {
            return (value == null || value.isEmpty)
                ? 'enter_password'.tr
                : null;
          },
        ),
        ElevatedButton.icon(
          icon: const Icon(
            Icons.access_alarm,
            size: 0,
          ),
          label: Text('login'.tr),
          onPressed: authLoginLoading,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _formType = FormType.register;
            });
          },
          child: Text('not_have_account'.tr),
        )
      ]),
    );
  }

  Form registerForm() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextFormField(
          controller: emailCtr..text = "george.bluth@reqres.in",
          decoration: inputDecoration('E-mail', Icons.person),
          validator: (value) {
            return (value == null || value.isEmpty) ? 'enter_email'.tr : null;
          },
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: passwordCtr..text = "123456",
          decoration: inputDecoration('password'.tr, Icons.lock),
          validator: (value) {
            return (value == null || value.isEmpty)
                ? 'enter_password'.tr
                : null;
          },
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          initialValue: "123456",
          validator: (value) {
            return (value == null || value.isEmpty || value != passwordCtr.text)
                ? 'password_not_match'.tr
                : null;
          },
          decoration: inputDecoration('retype_password'.tr, Icons.lock),
        ),
        ElevatedButton.icon(
          icon: const Icon(
            Icons.access_alarm,
            size: 0,
          ),
          label: Text('register'.tr),
          onPressed: authRegisterLoading,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _formType = FormType.login;
            });
          },
          child: Text('login'.tr),
        )
      ]),
    );
  }

  // This function will be triggered when the button is pressed
  void authLoginLoading() async {
    LoadingOverlay.of(context).show();
    await Future.delayed(const Duration(seconds: 0));

    if (formKey.currentState?.validate() ?? false) {
      String sStatusMessage = await AuthController.authInstance.login(
        emailCtr.text.trim(),
        passwordCtr.text.trim(),
      );

      if (sStatusMessage != 'OK') {
        Get.defaultDialog(
            middleText: sStatusMessage,
            textConfirm: 'OK',
            confirmTextColor: Colors.white,
            onConfirm: () {
              Get.back();
            });
      }
    }

    LoadingOverlay.of(context).hide();
  }

  void authRegisterLoading() async {
    LoadingOverlay.of(context).show();
    await Future.delayed(const Duration(seconds: 0));

    if (formKey.currentState?.validate() ?? false) {
      String sStatusMessage = await AuthController.authInstance.register(
        emailCtr.text.trim(),
        passwordCtr.text.trim(),
      );

      if (sStatusMessage != 'OK') {
        Get.defaultDialog(
            middleText: sStatusMessage,
            textConfirm: 'OK',
            confirmTextColor: Colors.white,
            onConfirm: () {
              Get.back();
            });
      }
    }

    LoadingOverlay.of(context).hide();
  }
}

InputDecoration inputDecoration(String labelText, IconData iconData,
    {String? prefix, String? helperText}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    helperText: helperText,
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.grey),
    fillColor: Colors.grey.shade200,
    filled: true,
    prefixText: prefix,
    prefixIcon: Icon(
      iconData,
      size: 20,
    ),
    prefixIconConstraints: const BoxConstraints(minWidth: 60),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black)),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black)),
  );
}

enum FormType { login, register }
