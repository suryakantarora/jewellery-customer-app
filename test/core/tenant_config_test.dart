import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/core/media/image_ref.dart';
import 'package:jewellery_customer/core/tenant/demo_tenant_repository.dart';
import 'package:jewellery_customer/core/tenant/tenant_config.dart';
import 'package:jewellery_customer/core/tenant/tenant_palette.dart';
import 'package:jewellery_customer/core/theme/color_parsing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TenantConfig.fromJson', () {
    late Map<String, dynamic> json;

    setUpAll(() {
      json =
          jsonDecode(File('assets/demo/tenant.json').readAsStringSync())
              as Map<String, dynamic>;
    });

    test('parses the bundled demo tenant completely', () {
      final tenant = TenantConfig.fromJson(json);
      expect(tenant.key, 'fino');
      expect(tenant.brandName, 'Fino Jewellery');
      expect(tenant.brandMark, 'FINO');
      expect(tenant.tagline, isNotEmpty);
      expect(tenant.logoLight, isA<AssetImageRef>());
      expect(tenant.paletteId, 'ruby');
      expect(tenant.palette.primary, const Color(0xFFE40046));
      expect(tenant.darkPalette.bg, const Color(0xFF0E0C0D));
      expect(tenant.fontDisplay, 'PlayfairDisplay');
      expect(tenant.currency.code, 'LAK');
      expect(tenant.currency.symbol, '₭');
      expect(tenant.currency.decimals, 0);
      expect(tenant.currency.symbolFirst, isTrue);
      expect(tenant.supportedLocales, ['en', 'lo']);
      expect(tenant.defaultLocale, 'en');
      expect(tenant.contact.phone, isNotNull);
      expect(tenant.flag('reviews'), isTrue);
      expect(tenant.flag('nonexistent'), isFalse);
      expect(tenant.freeDeliveryThreshold, 500000);
      expect(tenant.taxRate, closeTo(.07, 1e-9));
      expect(tenant.allowedPalettes, hasLength(6));
    });

    test('palette parses rgba() scrims and RGB shadow triples', () {
      final palette = TenantPalette.fromJson(
        json['palette'] as Map<String, dynamic>,
      );
      expect(palette.scrim.a, closeTo(.55, .01));
      expect((palette.shadowRgb.r * 255).round(), 92);
      expect(palette.shadow(.5).a, closeTo(.5, .01));
    });

    test('palette round-trips through toJson', () {
      final palette = TenantPalette.fromJson(
        json['darkPalette'] as Map<String, dynamic>,
      );
      final again = TenantPalette.fromJson(palette.toJson());
      expect(again.border.toARGB32(), palette.border.toARGB32());
      expect(again.primary.toARGB32(), palette.primary.toARGB32());
    });

    test('a missing palette role is a FormatException', () {
      final broken = Map<String, dynamic>.from(
        json['palette'] as Map<String, dynamic>,
      )..remove('accent');
      expect(() => TenantPalette.fromJson(broken), throwsFormatException);
    });
  });

  group('parseColor', () {
    test('accepts every notation', () {
      expect(parseColor('#fff'), const Color(0xFFFFFFFF));
      expect(parseColor('#e40046'), const Color(0xFFE40046));
      expect(parseColor('#80e40046'), const Color(0x80E40046));
      expect(parseColor('rgb(1, 2, 3)'), const Color(0xFF010203));
      expect(parseColor('rgba(0,0,0,0.65)').a, closeTo(.65, .01));
      expect(() => parseColor('red'), throwsFormatException);
    });
  });

  test('DemoTenantRepository loads from the asset bundle', () async {
    final tenant = await const DemoTenantRepository().load('anything');
    expect(tenant.key, 'fino');
  });
}
