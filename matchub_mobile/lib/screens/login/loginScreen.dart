import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:matchub_mobile/navigation/navigation.dart';
import 'package:matchub_mobile/screens/login/resetPassword.dart';
import 'package:matchub_mobile/screens/login/registerScreen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/roundedButton.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: deviceSize.height,
          child: Stack(
            children: [
              Scaffold(
                body: CustomPaint(
                  painter: CurvePainter(),
                  size: MediaQuery.of(context).size,
                ),
                resizeToAvoidBottomInset: false,
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: EdgeInsets.only(top: deviceSize.height * 0.1),
                  child: Container(
                      width: deviceSize.width,
                      height: deviceSize.height * 0.45,
                      child: Center(
                          child: Image.asset(
                        "assets/images/login-search.png",
                        fit: BoxFit.contain,
                      ))),
                ),
                resizeToAvoidBottomInset: false,
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(height: deviceSize.height * 0.49),
                    Container(
                      padding: EdgeInsets.only(top: deviceSize.height * 0.01),
                      decoration: BoxDecoration(
                          color: kScaffoldColor,
                          borderRadius: BorderRadius.circular(40)),
                      child: Container(
                        width: deviceSize.width,
                        child: LoginCard(),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ));

    // resizeToAvoidBottomInset: false,
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
      ..color = Color(0xFFe8f1ff)
      ..style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.40);
    path.quadraticBezierTo(size.width * 0.45, size.height * 0.50,
        size.width * 1, size.height * 0.40);
    // path.quadraticBezierTo(size.width * 0.75, size.height * 0.355, size.width,
    //     size.height * 0.365);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    // path.moveTo(0, size.height * 0.55);
    // path.quadraticBezierTo(size.width * 0.25, size.height * 0.525,
    //     size.width * 0.56, size.height * 0.41);
    // path.quadraticBezierTo(size.width * 0.75, size.height * 0.355, size.width,
    //     size.height * 0.365);
    // path.lineTo(size.width, 0);
    // path.lineTo(0, 0);
    // path.close();

    canvas.drawPath(path, paint);

    // var path2 = Path();
    // var paint2 = new Paint()
    //   // ..shader = gradient.createShader(rect)
    //   ..color = Colors.white
    //   ..style = PaintingStyle.fill;
    // path2.moveTo(size.width * 0.45, size.height);
    // path2.quadraticBezierTo(size.width * 0.55, size.height * 0.95,
    //     size.width * 0.66, size.height * 0.85);
    // path2.quadraticBezierTo(
    //     size.width * 0.80, size.height * 0.70, size.width, size.height * 0.675);
    // path2.lineTo(size.width, size.height);
    // path2.lineTo(size.width * 0.45, size.height);
    // path2.close();

    // canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class LoginCard extends StatefulWidget {
  LoginCard();

  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'username': '',
    'password': '',
  };
  var _isSubmitLoading = false;
  final _passwordController = TextEditingController();
  bool hasBiometrics = false;
  var _isLoading;

  @override
  void initState() {
    setState(() => _isLoading = true);
    initialiseBiometrics();
  }

  initialiseBiometrics() async {
    final prefs = await SharedPreferences.getInstance();
    hasBiometrics = prefs.get(
          "biometricsEnabled",
        ) ??
        false;
    print("Log in screen: Biometrics setting: " +
        prefs.getBool("biometricsEnabled").toString());
    setState(() => _isLoading = false);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isSubmitLoading = true;
    });
    try {
      // Log user in
      await Provider.of<Auth>(context, listen: false).login(
        _authData['username'],
        _authData['password'],
      );
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      showErrorDialog(error.toString(), context);
    }

    setState(() {
      _isSubmitLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return _isLoading
        ? Container()
        : Container(
            padding: EdgeInsets.symmetric(
                horizontal: 4 * SizeConfig.widthMultiplier),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
                    child: Text(
                      'Welcome Back',
                      style: TextStyle(
                          height: 1.1,
                          color: Colors.grey[800],
                          fontSize: 30,
                          fontFamily: 'Quicksand'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
                    child: Text(
                      'Map. Match. Motivate.',
                      style: TextStyle(
                          height: 1.1,
                          color: Colors.grey[500],
                          fontSize: 16,
                          fontFamily: 'Quicksand'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: deviceSize.width * 0.1,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Container(
                          color: Colors.grey[200].withOpacity(0.1),
                          child: TextFormField(
                            style: TextStyle(color: Colors.grey[700]),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Colors.grey[700],
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              _authData['username'] = value;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          color: Colors.grey[200].withOpacity(0.1),
                          child: TextFormField(
                            style: TextStyle(color: Colors.grey[700]),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Colors.grey[700],
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[700],
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[700],
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
                        ),
                        SizedBox(height: 20),
                        if (_isSubmitLoading)
                          CircularProgressIndicator()
                        else
                          RoundedButton(
                            text: 'LOGIN',
                            press: _submit,
                            color: kSecondaryColor,
                          ),
                        Row(children: [
                          Expanded(
                            child: FlatButton(
                              child: Text('${'Forgot password?'}',
                                  style: TextStyle(
                                      color: Colors.grey[850],
                                      decoration: TextDecoration.underline)),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ResetPassword(email: _authData['email']),
                                ));
                              },
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 4),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              textColor: kAccentColor,
                            ),
                          ),
                          if (hasBiometrics)
                            FlatButton(
                              child: Text('${'Fingerprint'}',
                                  style: TextStyle(
                                      color: Colors.grey[850],
                                      decoration: TextDecoration.underline)),
                              onPressed: () async {
                                final LocalAuthentication auth =
                                    LocalAuthentication();
                                {
                                  bool authenticateViaBiometrics = false;
                                  authenticateViaBiometrics =
                                      await auth.authenticateWithBiometrics(
                                          localizedReason:
                                              'Use biometrics to verify your identity',
                                          useErrorDialogs: true,
                                          stickyAuth: false);

                                  if (authenticateViaBiometrics) {
                                    await Provider.of<Auth>(context,listen: false).tryAutoLogin(biometricBypass: true);
                                  }
                                }
                              },
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 4),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              textColor: kAccentColor,
                            ),
                        ]),
                        FlatButton(
                          child: Text('${'Dont have an account? Sign up now'}',
                              style: TextStyle(color: Colors.grey[850])),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ));
                          },
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 4),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          textColor: kAccentColor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
