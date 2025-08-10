// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:virtual_salao/main.dart';

void main() {
  testWidgets('Login screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VirtualSalaoApp());

    // Verifica se a AppBar com o texto 'Login' está presente
    expect(find.text('Login'), findsOneWidget);

    // Verifica se os campos de email e senha estão presentes
    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Senha'), findsOneWidget);

    // Verifica se o botão 'Entrar' está presente
    expect(find.widgetWithText(ElevatedButton, 'Entrar'), findsOneWidget);
  });
}
