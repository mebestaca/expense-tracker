import 'package:flutter/material.dart';

import '../../services/authentication.dart';
import '../../shared/widgets/error_card.dart';
import '../../shared/text_decoration.dart';
import '../../shared/widgets/loading_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.toggleView}) : super(key: key);

  final Function toggleView;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String _email = "";
  String _password = "";
  String _errorText = "";
  bool _passwordVisibility = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Stack(
        children: [
          Center(
            child: SafeArea(
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(10.0),
                    scrollDirection: Axis.vertical,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.black
                          )
                      ),
                      child: Column(
                          children: [
                            Visibility(
                              visible: _errorText.isNotEmpty ? true : false,
                              child: ErrorCard(errorText: _errorText),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                decoration: fieldStyle.copyWith(
                                    hintText: "sample@example.com",
                                    labelText: "email"
                                ),
                                onChanged: (val) {
                                  _email = val;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                obscureText: _passwordVisibility,
                                decoration: fieldStyle.copyWith(
                                  hintText: "password",
                                  labelText: "Password",
                                  suffixIcon:
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisibility = !_passwordVisibility;
                                        });
                                      },
                                      icon: Icon(_passwordVisibility ? Icons.visibility : Icons.visibility_off )
                                  ),
                                ),
                                onChanged: (val) {
                                  _password = val;
                                },

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isLoading = true;
                                        });

                                        FocusManager.instance.primaryFocus?.unfocus();

                                        dynamic result = await AuthenticationService().signInEmail(
                                            email: _email,
                                            password: _password
                                        );


                                        if (result is String){
                                          setState(() {
                                            _errorText = result.replaceAll(RegExp('\\[.*?\\]'), '').trim();
                                            _isLoading = false;
                                          });
                                        }

                                      }
                                    },
                                    child: const Text("Login")),
                              ),
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(child: Container()),
                                const Text(
                                    "No account yet?"
                                ),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.toggleView();
                                      });
                                    },
                                    child: const Text("Register Here")
                                ),
                                Expanded(child: Container())
                              ],
                            ),
                          ]
                      ),
                    ),
                  )
              ),
            ),
          ),
          Visibility(
              visible: _isLoading, child: const Loading()
          ),
        ],
      ),
    );
  }
}
