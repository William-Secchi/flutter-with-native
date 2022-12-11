import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  late MethodChannel _channel;
  int? _batteryLevel;
  String _error = 'Unknown';

  @override
  void initState() {
    super.initState();
    _channel = const MethodChannel('com.example.method_channel/battery');
    _loadBatteryLevel();
  }

  Future<void> _loadBatteryLevel() async {
    int batteryLevel;
    try {
      batteryLevel = await _channel.invokeMethod('getBatteryLevel');
    } on PlatformException catch (e) {
      setState(() {
        _error = e.message!;
      });
      return;
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your battery level is:',
            ),
            Text(
              '${_batteryLevel ?? 'Unknown'}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _loadBatteryLevel(),
        tooltip: 'Check Battery Level',
        child: const Icon(Icons.battery_3_bar_rounded),
      ),
    );
  }
}
