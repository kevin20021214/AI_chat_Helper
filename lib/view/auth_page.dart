import 'package:flutter/material.dart';
import 'package:final_project/services/authentication.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final _form = GlobalKey<FormState>();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  var _isAuthenticating = false;
  late RiveAnimationController _controller;
  final String _animationName = '16717185';
  //final String _animationName = 'Edit Icon';
  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation(_animationName, autoplay: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 30,
                  left: 30,
                  right: 30,
                ),
                width: 150,
                child: Center(child: Text('聊天助手',style: TextStyle(fontFamily:'abc',fontWeight: FontWeight.bold, fontSize: 30, color: Theme.of(context).colorScheme.onPrimary),),),
              ),
              SizedBox(
              height: 300,
              width: 300,
              child: RiveAnimation.asset(
                'assets/new_file.riv',
                controllers: [_controller],
                onInit: (_) => setState(() => _controller.isActive = true),
                ),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              key: const ValueKey('email'),
                              decoration: const InputDecoration(
                                  labelText: 'Email'),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return '請輸入正確的電子郵件';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredEmail = value!;
                              },
                            ),
                             if (!_isLogin)
                              TextFormField(
                                key: const ValueKey('name'),
                                decoration: const InputDecoration(
                                    labelText: '使用者名稱'),
                                enableSuggestions: false,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 4) {
                                    return '使用者名稱至少需要四個字';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredUsername = value!;
                                },
                              ),
                            TextFormField(
                              key: const ValueKey('password'),
                              decoration:
                                  const InputDecoration(labelText: '密碼'),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return '請輸入正確的密碼';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredPassword = value!;
                              },
                            ),
                            const SizedBox(height: 24),
                            if (_isAuthenticating)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            if (!_isAuthenticating) ...[
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: _submit,
                                  child: Text(_isLogin ? '登入' : '註冊'),
                                ),
                              ),
                              if (_isLogin) ...[
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: _logInWithGoogle,
                                    icon: SvgPicture.asset(
                                      'assets/images/logo_google.svg',
                                      height: 20.0,
                                      width: 20.0,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.grey[700],
                                      foregroundColor: Colors.white,
                                    ),
                                    label: const Text('Google登入'),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 24),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin
                                    ? '帳號創建'
                                    : '已有帳號'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) return;

    _form.currentState!.save();

    final authenticationService =
        Provider.of<AuthenticationService>(context, listen: false);
    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        await authenticationService.logIn(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        await authenticationService.signUp(
          context: context,
          email: _enteredEmail,
          password: _enteredPassword,
          name: _enteredUsername,
        );
      }

      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    } catch (error) {
      debugPrint('Authentication failed with error: $error');
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication failed with error: $error'),
          ),
        );
      }
    }
  }

  void _logInWithGoogle() async {
    final authenticationService =
        Provider.of<AuthenticationService>(context, listen: false);
    try {
      setState(() {
        _isAuthenticating = true;
      });

      await authenticationService.logInWithGoogle(context);

      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    } catch (error) {
      debugPrint('Google Sign-in failed with error: $error');
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google Sign-in failed with error: $error'),
          ),
        );
      }
    }
  }
}
