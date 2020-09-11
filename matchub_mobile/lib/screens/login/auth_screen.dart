import 'package:flutter/material.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF89c9b8),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: deviceSize.height,
          child: Stack(
            children: [
              CustomPaint(
                painter: CurvePainter(),
                size: MediaQuery.of(context).size,
              ),
              Positioned(
                top: deviceSize.height * 0.1,
                child: Container(
                  width: deviceSize.width,
                  color: Colors.transparent,
                  child: AuthCard(),
                ),
              ),
            ],
          ),
        ),
      ),
      // resizeToAvoidBottomInset: false,
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.50);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.525,
        size.width * 0.56, size.height * 0.41);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.355, size.width,
        size.height * 0.365);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BackgroundClipper oldClipper) => false;
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height / 2);
    var paint = new Paint()
      // ..shader = gradient.createShader(rect)
      ..color = Color(0xFF4F5560)
      ..style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.55);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.525,
        size.width * 0.56, size.height * 0.41);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.355, size.width,
        size.height * 0.365);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);

    var path2 = Path();
    var paint2 = new Paint()
      // ..shader = gradient.createShader(rect)
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    path2.moveTo(size.width * 0.45, size.height);
    path2.quadraticBezierTo(size.width * 0.55, size.height * 0.95,
        size.width * 0.66, size.height * 0.85);
    path2.quadraticBezierTo(
        size.width * 0.80, size.height * 0.70, size.width, size.height * 0.675);
    path2.lineTo(size.width, size.height);
    path2.lineTo(size.width * 0.45, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class AuthCard extends StatefulWidget {
  AuthMode authMode;
  AuthCard();

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'username': '',
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  @override
  void initState() {
    widget.authMode = AuthMode.Login;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Oops! Something went wrong...'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (widget.authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['username'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
            _authData['username'],
            _authData['email'],
            _authData['password'],
            ["USER"]);
      }
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(error.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (widget.authMode == AuthMode.Login) {
      setState(() {
        widget.authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        widget.authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  height: deviceSize.height * 0.3,
                  child: Stack(
                    children: [
                      Positioned(
                          top: deviceSize.height * 0.1,
                          left: deviceSize.width * 0.1,
                          child: Text(
                            widget.authMode == AuthMode.Signup
                                ? 'Create \nAccount'
                                : 'Welcome\nBack',
                            style: TextStyle(
                              height: 1.1,
                              color: Colors.grey[50],
                              fontSize: 44,
                              fontFamily: 'Boorsok',
                            ),
                          )),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: deviceSize.width * 0.1,
                ),
                child: Column(
                  children: [
                    if (widget.authMode == AuthMode.Signup)
                      TextFormField(
                        enabled: widget.authMode == AuthMode.Signup,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          _authData['email'] = value;
                        },
                      ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      // validator: (value) {
                      //   if (value.isEmpty || !value.contains('@')) {
                      //     return 'Invalid email!';
                      //   }
                      // },
                      onSaved: (value) {
                        _authData['username'] = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty || value.length < 8) {
                          return 'Password is too short!';
                        }
                      },
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                    ),
                    SizedBox(height: 100),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      RoundedButton(
                        text: widget.authMode == AuthMode.Login
                            ? 'LOGIN'
                            : 'SIGN UP',
                        press: _submit,
                        color: kAccentColor,
                      ),
                    FlatButton(
                      child: Text(widget.authMode == AuthMode.Login
                          ? '${'REGISTER'}'
                          : 'LOGIN'),
                      onPressed: _switchAuthMode,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textColor: kAccentColor,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
