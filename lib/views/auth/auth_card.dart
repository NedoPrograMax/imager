import 'package:flutter/material.dart';
import 'package:imager/bloc/app_bloc.dart';
import 'package:imager/bloc/app_event.dart';
import 'package:imager/views/auth/confirm_password_form.dart';
import 'package:imager/views/auth/email_form.dart';
import 'package:imager/views/auth/password_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/strings.dart';

typedef ValueSave = void Function(String? value);
typedef FieldSubmit = void Function(String? value);
typedef FieldValidate = String? Function(String? value);

class AuthCard extends StatefulWidget {
  const AuthCard({
    required this.availableHeight,
    super.key,
  });
  final double availableHeight;

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with TickerProviderStateMixin {
  final Map<String, String> formFieldValues = {
    "email": "",
    "password": "",
  };

  final passwordFocusNode = FocusNode();

  final confirmPasswordFocusNode = FocusNode();

// is used for animatiions and logic
  var _isLogin = true;

  late final Animation<double> _opacityAnimation;

  late final AnimationController _controller;

  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    super.initState();
  }

  void _switchLoginMode() {
    if (_isLogin) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void onSubmit() {
    _form.currentState?.save();
    if (_form.currentState?.validate() == true) {
      _form.currentState?.save();

      if (_isLogin) {
        context.read<AppBloc>().add(
              AppEventLogin(
                email: formFieldValues["email"]!,
                password: formFieldValues["password"]!,
              ),
            );
      } else {
        context.read<AppBloc>().add(
              AppEventSignUp(
                email: formFieldValues["email"]!,
                password: formFieldValues["password"]!,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableHeight = widget.availableHeight;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(bottom: 10),
        // 0.36 and 0.48 are results of summing all height in widgets below
        height: _isLogin ? availableHeight * 0.36 : availableHeight * 0.48,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                EmailForm(
                  // 0.12 is used in computating the total height (above_
                  //if want to change => change total height accordingly
                    height: availableHeight * 0.12,
                    onSubmit: (value) =>
                        FocusScope.of(context).requestFocus(passwordFocusNode),
                    onSaved: (value) {
                      formFieldValues["email"] = value ?? "";
                    }),
                PasswordForm(
                  height: availableHeight * 0.12,
                  passwordFocusNode: passwordFocusNode,
                  action:
                      !_isLogin ? TextInputAction.next : TextInputAction.done,
                  onSaved: (value) {
                    formFieldValues["password"] = value ?? "";
                  },
                  onSubmit: (value) {
                    if (!_isLogin) {
                      FocusScope.of(context)
                          .requestFocus(confirmPasswordFocusNode);
                    }
                  },
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  
                  height: _isLogin ? 0 : availableHeight * 0.12,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: ConfirmPasswordForm(
                      onValidate: (password) {
                        if (_isLogin) {
                          return null;
                        }
                        if (password != formFieldValues["password"]) {
                          return passwordConfirmDoesntMatch;
                        }

                        return null;
                      },
                      focusNode: confirmPasswordFocusNode,
                    ),
                  ),
                ),
                SizedBox(
                    height: availableHeight * 0.05,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: onSubmit,
                        child: Text(_isLogin ? login : signUp))),
                SizedBox(
                  height: availableHeight * 0.05,
                  child: TextButton(
                      onPressed: _switchLoginMode,
                      child: Text(_isLogin ? notRegistered : alreadyHaveAnAcc)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
