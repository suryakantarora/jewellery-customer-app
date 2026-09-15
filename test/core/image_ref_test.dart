import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/core/media/image_ref.dart';

void main() {
  group('ImageRef.fromString', () {
    test('asset://', () {
      final ref = ImageRef.fromString('asset://images/catalogue/1.jpg');
      expect(ref, isA<AssetImageRef>());
      expect((ref as AssetImageRef).assetPath, 'assets/images/catalogue/1.jpg');
      expect(ref.toString(), 'asset://images/catalogue/1.jpg');
    });

    test('plain assets/ path is an asset too', () {
      final ref = ImageRef.fromString('assets/images/ui/avtr2.png');
      expect((ref as AssetImageRef).assetPath, 'assets/images/ui/avtr2.png');
    });

    test('key://', () {
      final ref = ImageRef.fromString('key://abc-123');
      expect(ref, isA<KeyImageRef>());
      expect((ref as KeyImageRef).storageKey, 'abc-123');
    });

    test('bare storage key from the ERP is a key ref', () {
      expect(ImageRef.fromString('items/42/primary.jpg'), isA<KeyImageRef>());
    });

    test('https://', () {
      final ref = ImageRef.fromString('https://cdn.example.com/a.jpg');
      expect(ref, isA<UrlImageRef>());
      expect((ref as UrlImageRef).uri.host, 'cdn.example.com');
    });

    test('empty and null are none', () {
      expect(ImageRef.fromString(null).isEmpty, isTrue);
      expect(ImageRef.fromString('   ').isEmpty, isTrue);
    });

    test('equality is by canonical string', () {
      expect(ImageRef.fromString('key://x'), const ImageRef.key('x'));
      expect(ImageRef.fromString('key://x').hashCode, const ImageRef.key('x').hashCode);
    });
  });
}
