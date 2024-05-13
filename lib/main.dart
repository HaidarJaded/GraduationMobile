import 'package:flutter/material.dart';
import 'package:graduation_mobile/Controllers/auth_controller.dart';
import 'package:graduation_mobile/helper/app_context.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      navigatorKey: AppContext.navigatorKey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> _incrementCounter() async {
    if (await AuthController().login("admin@gmail.com", "#123456789H")) {
      SnackBarAlert()
          .alert("Login successfuly", color: const Color.fromRGBO(0, 200, 0, 1));
    } else {
      SnackBarAlert()
          .alert("Login failed");
    }
    // try {
    //   throw HttpException(401);
    // } on HttpException catch (e) {
    //   if (e.statusCode == 401) {
    //     return WidgetsBinding.instance.addPostFrameCallback((_) {
    //       Navigator.of(AppContext.navigatorKey.currentContext!)
    //           .pushAndRemoveUntil(
    //         MaterialPageRoute(builder: (context) => const LoginPage()),
    //         (route) => false,
    //       );
    //     });
    //   }
    // }
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
