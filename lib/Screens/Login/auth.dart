/*
 *  This file is part of BlackHole (https://github.com/Sangwan5688/BlackHole).
 * 
 * BlackHole is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * BlackHole is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with BlackHole.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Copyright (c) 2021-2022, Ankit Sangwan
 */

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

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Uuid uuid = const Uuid();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future _addUserData(String name) async {
    int? status;
    if(name.trim() == ''){
      await Hive.box('settings').put('name', AppLocalizations.of(context)!.guest);
      await Hive.box('settings').put('login', false);
    }else{
      await Hive.box('settings').put('name', name.trim());
      await Hive.box('settings').put('login', true);
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
      'name': name,
      'accountCreatedOn': '${createDate[0]} IST',
      'timeZone':
          "Zone: ${now.timeZoneName} Offset: ${now.timeZoneOffset.toString().replaceAll('.000000', '')}",
    });

    while (status == null || status == 409) {
      userId = uuid.v1();
      status = await SupaBase().createUser({
        'id': userId,
        'name': name,
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
                          Navigator.popAndPushNamed(context, '/pref');
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
                                ///Enter Username
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
                                          .enterPassword,
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
                                ///Language setting
                                GestureDetector(
                                  onTap: () async {
                                    if(usernameController.text.trim() != '' && passwordController.text.trim() != ''){
                                      await _addUserData(
                                        usernameController.text.trim(),
                                      );
                                      if (Hive.box('settings').get('preferredLanguage') == null || Hive.box('settings').get('region') == null) {
                                        Navigator.popAndPushNamed(context, '/pref');
                                      }
                                    }
                                    /*if (usernameController.text.trim() == '') {
                                      await _addUserData('');
                                    } else {

                                    }*/

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
                                            .getStarted,
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
                                     text: "Don't have an account? ",
                                     style: TextStyle(
                                       color: Colors.grey.withOpacity(0.7),
                                     ),
                                     children: <TextSpan>[
                                       TextSpan(
                                         text: 'Sign Up Now',
                                         style: TextStyle(color: Theme.of(context).colorScheme.secondary,),
                                         recognizer: TapGestureRecognizer()..onTap = (){
                                           Navigator.pop(context);
                                           Navigator.pushNamed(context, '/signup');
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
