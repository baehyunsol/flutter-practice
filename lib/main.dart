import 'package:flutter/material.dart';
import 'package:note_app/privateNoteManager.dart';
import 'package:note_app/publicNoteManager.dart';

void main() {
  runApp(MyApp());
}

// https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // https://api.flutter.dev/flutter/material/MaterialApp-class.html
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // https://api.flutter.dev/flutter/material/Scaffold-class.html
    // https://dart.dev/language/functions#named-parameters
    return Scaffold(
      appBar: AppBar(
        title: Text('Note App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  // https://api.flutter.dev/flutter/material/MaterialPageRoute-class.html
                  MaterialPageRoute(builder: (context) => const PrivateNotePage()),
                );
              },
              child: Text('Private Note'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PublicNotePage("http://18.189.157.125:8080")),
                );
              },
              child: Text('Public Note'),
            ),
          ],
        ),
      ),
    );
  }
}
