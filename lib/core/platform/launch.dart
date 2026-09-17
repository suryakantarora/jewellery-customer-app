import 'package:url_launcher/url_launcher.dart';

/// Thin wrappers over url_launcher so screens never build schemes by hand.
/// Every call returns whether the platform accepted the request, so the
/// caller can fall back to copying the value.
abstract final class Launch {
  static Future<bool> phone(String number) =>
      _open(Uri(scheme: 'tel', path: number.replaceAll(' ', '')));

  static Future<bool> whatsapp(String number, {String? text}) => _open(
    Uri.https('wa.me', '/${number.replaceAll(RegExp(r'[^0-9]'), '')}', {
      if (text != null) 'text': text,
    }),
    external: true,
  );

  static Future<bool> email(String address, {String? subject}) => _open(
    Uri(
      scheme: 'mailto',
      path: address,
      query: subject == null ? null : 'subject=$subject',
    ),
  );

  /// Opens the platform maps app at a pin.
  static Future<bool> maps(double lat, double lng, {String? label}) => _open(
    Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': label == null ? '$lat,$lng' : '$lat,$lng($label)',
    }),
    external: true,
  );

  static Future<bool> web(Uri uri) => _open(uri, external: true);

  static Future<bool> _open(Uri uri, {bool external = false}) async {
    try {
      return await launchUrl(
        uri,
        mode: external
            ? LaunchMode.externalApplication
            : LaunchMode.platformDefault,
      );
    } on Object {
      return false;
    }
  }
}
