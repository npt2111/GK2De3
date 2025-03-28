import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // <-- Thêm dòng này

void main() {
  runApp(const BirthdayCountdownApp());
}

class BirthdayCountdownApp extends StatelessWidget {
  const BirthdayCountdownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BirthdayCountdownScreen(),
    );
  }
}

class BirthdayCountdownScreen extends StatefulWidget {
  @override
  _BirthdayCountdownScreenState createState() =>
      _BirthdayCountdownScreenState();
}

class _BirthdayCountdownScreenState extends State<BirthdayCountdownScreen> {
  final TextEditingController _dateController = TextEditingController();
  String _countdownMessage = "";

  static const platform = MethodChannel('com.example.birthdaycountdown/channel');

  void _calculateCountdown() {
    if (_dateController.text.isEmpty) return;

    try {
      DateFormat format = DateFormat("dd/MM");
      DateTime birthDate = format.parse(_dateController.text);
      DateTime now = DateTime.now();
      DateTime nextBirthday = DateTime(now.year, birthDate.month, birthDate.day);

      if (nextBirthday.isBefore(now)) {
        nextBirthday = DateTime(now.year + 1, birthDate.month, birthDate.day);
      }

      int daysLeft = nextBirthday.difference(now).inDays;
      setState(() {
        _countdownMessage = "Còn $daysLeft ngày đến sinh nhật!";
      });

      _scheduleNotification(daysLeft);
    } catch (e) {
      setState(() {
        _countdownMessage = "Ngày nhập không hợp lệ!";
      });
    }
  }

 
  Future<void> _scheduleNotification(int daysLeft) async {
    try {
      await platform.invokeMethod('scheduleNotification', {
        "title": "Sinh nhật sắp tới!",
        "body": "Còn $daysLeft ngày nữa đến sinh nhật!",
      });
    } catch (e) {
      print("Lỗi thông báo: $e");
    }
  }


  Future<void> _shareCountdown() async {
    try {
      await platform.invokeMethod('shareCountdown', {
        "text": _countdownMessage
      });
    } catch (e) {
      print("Lỗi chia sẻ: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đếm ngược sinh nhật")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nhập ngày sinh (dd/MM)",
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateCountdown,
              child: const Text("Tính ngày còn lại"),
            ),
            const SizedBox(height: 20),
            Text(
              _countdownMessage,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _shareCountdown,
              child: const Text("Chia sẻ"),
            ),
          ],
        ),
      ),
    );
  }
}
