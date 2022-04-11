import 'package:blackhole/CustomWidgets/gradient_containers.dart';
//import 'package:blackhole/Helpers/backup_restore.dart';
//import 'package:blackhole/Helpers/config.dart';
import 'package:blackhole/Helpers/supabase.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  Uuid uuid = const Uuid();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future _addUserData(String email) async {
    int? status;
    if(email.trim() == ''){
      await Hive.box('settings').put('email', AppLocalizations.of(context)!.guest);
      await Hive.box('settings').put('register', false);
    }else{
      await Hive.box('settings').put('email', AppLocalizations.of(context)!.enterEmail);
      await Hive.box('settings').put('register', true);
    }

    final DateTime now = DateTime.now();
    final List createDate = now
        .toUtc()
        .add(const Duration(hours: 5, minutes: 30))
        .toString()
        .split('.')
      ..removeLast()
      ..join('.');

    String userId = uuid.v1();
    status = await SupaBase().createUser({
      'id': userId,
      'email': email,
      'accountCreatedOn': '${createDate[0]} IST',
      'timeZone':
      "Zone: ${now.timeZoneName} Offset: ${now.timeZoneOffset.toString().replaceAll('.000000', '')}",
    });

    while (status == null || status == 409) {
      userId = uuid.v1();
      status = await SupaBase().createUser({
        'id': userId,
        'email': email,
        'accountCreatedOn': '${createDate[0]} IST',
        'timeZone':
        "Zone: ${now.timeZoneName} Offset: ${now.timeZoneOffset.toString().replaceAll('.000000', '')}",
      });
    }
    await Hive.box('settings').put('userId', userId);
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Positioned(
                left: MediaQuery.of(context).size.width / 1.85,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: const Image(
                    image: AssetImage(
                      'assets/icon-white-trans.png',
                    ),
                  ),
                ),
              ),
              const GradientContainer(
                child: null,
                opacity: true,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /*TextButton(
                        onPressed: () async {
                          await restore(context);
                          GetIt.I<MyTheme>().refresh();
                          Navigator.popAndPushNamed(context, '/');
                        },
                        child: Text(
                          AppLocalizations.of(context)!.restore,
                        ),
                      ),*/

                      ///Skip
                      TextButton(
                        onPressed: () async {
                          await _addUserData('');
                          Navigator.popAndPushNamed(context, '/pref2');
                        },
                        child: Text(
                          AppLocalizations.of(context)!.skip,
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              ///Logo
                              children: [
                                //Image.network('https://muxic.asia/static/media/image3.048d2b53714adde34758.webp', width: MediaQuery.of(context).size.width-60,)
                                Image(
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width-90,
                                  image:AssetImage(
                                    Theme.of(context).brightness == Brightness.dark
                                        ? 'assets/Logo_(remove background) .png'
                                    // 'assets/LogoWhite.png'
                                        : 'assets/MUXICbiglogo.png',
                                  ),),
                                /*RichText(
                                  text: TextSpan(
                                    text: 'Black\nHole\n',
                                    style: TextStyle(
                                      height: 0.97,
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    children: <TextSpan>[
                                      const TextSpan(
                                        text: 'Music',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 80,
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 80,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),*/
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Column(
                              children: [
                                ///Enter User name
                                Container(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                    left: 10,
                                    right: 10,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  height: 57.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[900],
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5.0,
                                        offset: Offset(0.0, 3.0),
                                      )
                                    ],
                                  ),
                                  child: TextField(
                                    controller: usernameController,
                                    textAlignVertical: TextAlignVertical.center,
                                    textCapitalization:
                                    TextCapitalization.sentences,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1.5,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      border: InputBorder.none,
                                      hintText: AppLocalizations.of(context)!
                                          .enterName,
                                      hintStyle: const TextStyle(
                                        color: Colors.white60,
                                      ),
                                    ),
                                    onSubmitted: (String value) async {
                                      /*if (value.trim() == '') {
                                        await _addUserData(
                                          AppLocalizations.of(context)!.guest,
                                        );
                                      } else {
                                        await _addUserData(value.trim());
                                      }
                                      Navigator.popAndPushNamed(
                                        context,
                                        '/pref',
                                      );*/
                                    },
                                  ),
                                ),
                                ///Enter Email
                                Container(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                    left: 10,
                                    right: 10,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  height: 57.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[900],
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5.0,
                                        offset: Offset(0.0, 3.0),
                                      )
                                    ],
                                  ),
                                  child: TextField(
                                    controller: emailController,
                                    textAlignVertical: TextAlignVertical.center,
                                    textCapitalization:
                                    TextCapitalization.sentences,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1.5,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      border: InputBorder.none,
                                      hintText: AppLocalizations.of(context)!
                                          .enterEmail,
                                      hintStyle: const TextStyle(
                                        color: Colors.white60,
                                      ),
                                    ),
                                    onSubmitted: (String value) async {
                                      /*if (value.trim() == '') {
                                        await _addUserData(
                                          AppLocalizations.of(context)!.guest,
                                        );
                                      } else {
                                        await _addUserData(value.trim());
                                      }
                                      Navigator.popAndPushNamed(
                                        context,
                                        '/pref2',
                                      );*/
                                    },
                                  ),
                                ),
                                ///Enter Password
                                Container(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                    left: 10,
                                    right: 10,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  height: 57.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[900],
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5.0,
                                        offset: Offset(0.0, 3.0),
                                      )
                                    ],
                                  ),
                                  child: TextField(
                                    controller: passwordController,
                                    textAlignVertical: TextAlignVertical.center,
                                    textCapitalization:
                                    TextCapitalization.sentences,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1.5,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.password,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      border: InputBorder.none,
                                      hintText: AppLocalizations.of(context)!
                                          .enterNewPassword,
                                      hintStyle: const TextStyle(
                                        color: Colors.white60,
                                      ),
                                    ),
                                    onSubmitted: (String value) async {
                                      /*if (value.trim() == '') {
                                        await _addUserData(
                                          AppLocalizations.of(context)!.guest,
                                        );
                                      } else {
                                        await _addUserData(value.trim());
                                      }
                                      Navigator.popAndPushNamed(
                                        context,
                                        '/pref2',
                                      );*/
                                    },
                                  ),
                                ),
                                ///Confirm Password
                                Container(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                    left: 10,
                                    right: 10,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  height: 57.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[900],
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5.0,
                                        offset: Offset(0.0, 3.0),
                                      )
                                    ],
                                  ),
                                  child: TextField(
                                    controller: confirmPasswordController,
                                    textAlignVertical: TextAlignVertical.center,
                                    textCapitalization:
                                    TextCapitalization.sentences,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1.5,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.password,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      border: InputBorder.none,
                                      hintText: AppLocalizations.of(context)!
                                          .confirmNewPassword,
                                      hintStyle: const TextStyle(
                                        color: Colors.white60,
                                      ),
                                    ),
                                    onSubmitted: (String value) async {
                                      /*if (value.trim() == '') {
                                        await _addUserData(
                                          AppLocalizations.of(context)!.guest,
                                        );
                                      } else {
                                        await _addUserData(value.trim());
                                      }
                                      Navigator.popAndPushNamed(
                                        context,
                                        '/pref2',
                                      );*/
                                    },
                                  ),
                                ),
                                ///Register button
                                GestureDetector(
                                  onTap: () async {
                                    if(emailController.text.trim() != '' && passwordController.text.trim() != ''&& confirmPasswordController.text.trim() != ''
                                    && passwordController.text==confirmPasswordController.text ){
                                      await _addUserData(
                                        emailController.text.trim(),
                                      );
                                      if (Hive.box('settings').get('preferredLanguage') == null || Hive.box('settings').get('region') == null) {
                                        Navigator.popAndPushNamed(context, '/pref2');
                                      }
                                    }
                                    if (emailController.text.trim() == '') {
                                      await _addUserData('');
                                    } else {

                                    }

                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                    ),
                                    height: 55.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          offset: Offset(0.0, 3.0),
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .getRegister,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Already have an account? ",
                                      style: TextStyle(
                                        color: Colors.grey.withOpacity(0.7),
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Login',
                                          style: TextStyle(color: Theme.of(context).colorScheme.secondary,),
                                          recognizer: TapGestureRecognizer()..onTap = (){
                                            Navigator.pop(context);
                                            Navigator.pushNamed(context, '/auth');
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  /* child: InkWell(
                                    onTap: (){},
                                    child: Text("Don't have an account? Sign Up Now", style: TextStyle(color: Theme.of(context).colorScheme.secondary), textAlign: TextAlign.right,),
                                  ),*/
                                ),
                                /*Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .disclaimer,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .disclaimerText,
                                        style: TextStyle(
                                          color: Colors.grey.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),*/
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
