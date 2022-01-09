import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';

import 'package:flutter/services.dart';

import 'package:password_manager/AuthenticationPin.dart';
import 'package:password_manager/PasswordHome.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  late bool canCheckBiometrics;
  bool authenticated = false;

  @override
  void initState() {
    authenticate();
    main();
    super.initState();
    // _checkBiomentrics();
  }

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();

    final FlutterSecureStorage secureStorage = FlutterSecureStorage();

    var containsEncryptionKey = await secureStorage.containsKey(key: 'key');

    if (!containsEncryptionKey) {
      var key = Hive.generateSecureKey();
      await secureStorage.write(key: 'key', value: base64UrlEncode(key));
    }

    final key = await secureStorage.read(key: 'key');

    var encryptionKey = base64Url.decode(key!);

    print('Encryption key: $encryptionKey');

    await Hive.openBox('password',
        encryptionCipher: HiveAesCipher(encryptionKey));
  }

  Future<void> checkBiomentrics() async {
    bool canCheckBiometrics;
    try {
      var localAuth = LocalAuthentication();
      canCheckBiometrics = await localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }

    if (!mounted) return;

    setState(() {
      canCheckBiometrics = canCheckBiometrics;
    });
  }

  modalAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                  child: Text('Something went wrong',
                      style: GoogleFonts.getFont('Inter'))),
              content: Container(
                height: 75,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Text(
                    'You need to setup either PIN or Fingerprint Authentication to be able to use this App. \n I am doing this for you Safety!'),
              ),
              actions: [
                TextButton(
                  child: Text('I get it',
                      style: GoogleFonts.getFont('Inter', fontSize: 16)),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }

  Future<void> authenticate() async {
    try {
      var localAuth = LocalAuthentication();
      authenticated = await localAuth.authenticate(
          localizedReason: 'Please authenticate to show your passwords',
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: false);

      if (authenticated) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => PasswordHomePage()));
      } else {
        setState(() {});
      }
    } catch (e) {
      if (e.toString() == "NotAvailable") {
        modalAlert(context);
      }
    }
  }

  final List locale = [
    {'name': 'English', 'locale': Locale('en', 'US')},
    {'name': 'Turkish', 'locale': Locale('tr', 'TR')},
  ];
  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  buildLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text('Choose Your Language'),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Text(locale[index]['name']),
                        onTap: () {
                          print(locale[index]['name']);
                          updateLanguage(locale[index]['locale']);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.blue,
                    );
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'.tr,
            style: GoogleFonts.getFont('Inter', color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                buildLanguageDialog(context);
              },
              child: Icon(
                Icons.language,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Fingerprint'.tr,
                style: GoogleFonts.getFont('Inter',
                    fontSize: 24, color: Color(0xff6C5DD3))),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(18.0),
              height: 190,
              width: 190,
              decoration: BoxDecoration(
                  color: Color(0xff6C5DD3).withOpacity(0.3),
                  shape: BoxShape.circle),
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    color: Color(0xff6C5DD3), shape: BoxShape.circle),
                child: Icon(Icons.fingerprint_outlined,
                    size: 110, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AuthenticationPinPage())),
              child: Text('tryAgainPIN'.tr,
                  style: GoogleFonts.getFont('Inter',
                      fontSize: 18, color: Color(0xff6C5DD3))),
            ),
            if (!authenticated)
              Text('youNeed'.tr,
                  style: GoogleFonts.getFont('Inter',
                      fontSize: 15, color: Colors.red)),
            TextButton(
              onPressed: () => authenticate(),
              child: Text('tryAgainBIO'.tr,
                  style: GoogleFonts.getFont('Inter',
                      fontSize: 18, color: Color(0xff6C5DD3))),
            ),
          ],
        ),
      ),
    );
  }
}
