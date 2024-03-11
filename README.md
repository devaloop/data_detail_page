## Usage

```dart
import 'package:devaloop_data_detail_page/data_detail_page.dart';
import 'package:devaloop_form_builder/form_builder.dart';
import 'package:devaloop_form_builder/input_field_text.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DataDetailPage(
        title: 'Detail Doctor',
        subtitle: 'Detail Doctor',
        id: '001',
        inputFields: const [
          InputText(
            name: 'name',
            label: 'Name',
          ),
          InputText(
            name: 'email',
            label: 'Email (Google Account)',
            inputTextMode: InputTextMode.email,
          ),
        ],
        onInitial: (context, inputValues) {
          inputValues['name']!.setString('user');
          inputValues['email']!.setString('user@gmail.com');
        },
        onAfterValidation: (context, inputValues, isValid, erorMessage) {
          if (isValid) {
            if (!inputValues['email']!.getString()!.contains('gmail.com')) {
              erorMessage['email'] = 'Email must an google account (gmail.com)';
            }
          }
        },
        save: (id, inputValues) => Future(() async {
          // ignore: unused_local_variable
          var name = inputValues['name']!.getString()!;
          // ignore: unused_local_variable
          var email = inputValues['email']!.getString()!;

          await Future.delayed(Durations.extralong4);
        }),
        delete: (id) => Future(() async {
          await Future.delayed(Durations.extralong4);
        }),
      ),
    );
  }
}
```