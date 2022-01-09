import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        //ENGLISH LANGUAGE
        'en_US': {
          'Authentication': 'Authentication',
          'tryAgainPIN': 'Try again PIN',
          'tryAgainBIO': 'Try again Biometrics',
          'youNeed':
              'Oh ! You Need to authenticate to move forward. \nI am doing this for you Safety!',
          'Fingerprint': 'Fingerprint',
          'Your Passwords': 'Your Passwords',
          'No Value!': 'No Value',
          'Service': 'Service',
          'usernameInfo': 'Username/Email/Phone',
          'Password': 'Password',
          'Save': 'Save',
          'Copied to your Clipboard': 'Copied to your Clipboard',
        },
        //TURKISH LANGUAGE
        'tr_TR': {
          'Authentication': 'Kimlik Doğrulama',
          'tryAgainPIN': 'PIN"i tekrar deneyin',
          'tryAgainBIO': 'Parmak izini tekrar deneyin',
          'youNeed':
              'İlerlemek için kimlik doğrulaması yapman gerekir. Bunu senin güvenliğin için yapıyoruz!',
          'Fingerprint': 'Parmak İzi',
          'Your Passwords': 'Şifreleriniz',
          'No Value!': 'Değer yok',
          'Service': 'Servis',
          'usernameInfo': 'Kullanıcı Adı/Email/Telefon',
          'Password': 'Şifre',
          'Save': 'Kaydet',
          'Copied to your Clipboard': 'Panonuza kopyalandı',
        },
      };
}
