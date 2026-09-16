import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/features/home/home_screen.dart';
import 'package:jewellery_customer/features/onboarding/tutorial_screen.dart';
import 'package:jewellery_customer/features/onboarding/welcome_screen.dart';
import 'package:jewellery_customer/features/shell/app_shell.dart';
import 'package:jewellery_customer/features/splash/splash_screen.dart';

import '../support/app_harness.dart';

void main() {
  testWidgets('first run: splash → tour → welcome → guest → home', (tester) async {
    await bootApp(tester);
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('FINO'), findsWidgets);

    await settle(tester, 1200);
    await settle(tester, 500);
    expect(find.byType(TutorialScreen), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await settle(tester, 800);
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Fino Jewellery'), findsWidgets);

    await tester.tap(find.text('Continue as guest'));
    await settle(tester, 800);
    expect(find.byType(AppShell), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
    await unmount(tester);
  });
}
