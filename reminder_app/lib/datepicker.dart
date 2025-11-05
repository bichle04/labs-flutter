import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});
  @override
  State<DatePicker> createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  late DateTime dt;
  late TimeOfDay time;
  final _formKey = GlobalKey<FormState>();

  final FlutterLocalNotificationsPlugin fltrNotification =
      FlutterLocalNotificationsPlugin();

  List alarms = [];
  int counter = 0;
  List<Item> reminders = [];
  String? reminder;
  Map<int, Timer> activeTimers = {}; // Lưu trữ các Timer để có thể hủy

  @override
  void initState() {
    super.initState();
    dt = DateTime.now();
    time = TimeOfDay.now();
    _initTimezone();
    _initNotification();
  }

  @override
  void dispose() {
    // Hủy tất cả timer khi dispose widget
    for (var timer in activeTimers.values) {
      timer.cancel();
    }
    activeTimers.clear();
    print('🧹 Đã dọn dẹp ${activeTimers.length} timers');
    super.dispose();
  }

  Future<void> _initTimezone() async {
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      final tzName = tzInfo.identifier; // ✅ đúng field

      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (e) {
      print("Timezone error: $e");
      tz.setLocalLocation(tz.UTC);
    }
  }

  Future<void> _initNotification() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await fltrNotification.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (res) {
        print('📳 Notification clicked: ${res.payload}');
        _showDialog(res.payload);
      },
    );

    // Tạo notification channel cho Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel',
      'Lời nhắc',
      description: 'Thông báo lời nhắc',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        fltrNotification
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
      print('✅ Notification channel đã được tạo');
    }
  }

  Future<void> _schedule(DateTime time, int id) async {
    print('⏰ Đặt lịch nhắc cho: $time');
    print('📱 Nội dung: ${alarms[id][4]}');
    print('🕐 Thời gian hiện tại: ${DateTime.now()}');

    final difference = time.difference(DateTime.now());
    print('⏱️ Chênh lệch: ${difference.inSeconds} giây');

    if (difference.inSeconds <= 0) {
      print('⚠️ Thời gian đã qua, không thể đặt lịch');
      return;
    }

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel',
        'Lời nhắc',
        channelDescription: 'Thông báo lời nhắc',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
      ),
    );

    try {
      // Tạo Timer và lưu để có thể hủy sau này
      final timer = Timer(difference, () async {
        try {
          await fltrNotification.show(
            counter,
            "🔔 Lời nhắc",
            alarms[id][4],
            notificationDetails,
            payload: alarms[id][4],
          );
          print('✅ Lời nhắc được hiển thị: ${alarms[id][4]}');

          // Xóa timer khỏi map sau khi hoàn thành
          activeTimers.remove(counter);
        } catch (e) {
          print('❌ Lỗi hiển thị notification: $e');
        }
      });

      // Lưu timer để có thể hủy
      activeTimers[counter] = timer;

      print(
        '✅ Đã tạo Timer thành công cho ${difference.inSeconds} giây với ID: $counter',
      );
    } catch (e) {
      print('❌ Lỗi tạo Timer: $e');
    }

    setState(() {
      alarms[id][2] = time;
      alarms[id][3] = counter;
      counter++;
    });
  }

  Future pickDate(BuildContext context, int? index) async {
    DateTime? d = await showDatePicker(
      context: context,
      initialDate: index != null ? alarms[index][0] : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (d == null) return;
    setState(() => dt = d);
    pickTime(context, index);
  }

  Future pickTime(BuildContext context, int? index) async {
    TimeOfDay tod = TimeOfDay.now();
    TimeOfDay? t = await showTimePicker(
      context: context,
      initialTime: index != null
          ? alarms[index][1]
          : TimeOfDay(hour: tod.hour, minute: tod.minute + 1),
    );

    if (t == null) return;

    time = t;
    await _setReminder();

    if (reminder == null) return;

    // Tạo DateTime đúng cách từ ngày đã chọn và giờ đã chọn
    DateTime schedule = DateTime(
      dt.year,
      dt.month,
      dt.day,
      t.hour,
      t.minute,
      0, // giây = 0
    );

    print('📅 Ngày chọn: $dt');
    print('🕐 Giờ chọn: $t');
    print('⏰ Thời gian đặt lịch: $schedule');
    print('🕗 Thời gian hiện tại: ${DateTime.now()}');

    if (schedule.isAfter(DateTime.now())) {
      int id = alarms.length;

      setState(() {
        alarms.add([dt, time, false, counter, reminder]);
        reminders = _genItems(alarms);
      });

      await _schedule(schedule, id);

      // Hiển thị thông báo thành công
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Đã tạo lời nhắc: $reminder'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      reminder = null;
    } else {
      // Thông báo nếu thời gian đã qua
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Thời gian đã chọn đã qua. Vui lòng chọn thời gian trong tương lai.',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future _setReminder() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    size: 32,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Create New Reminder',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter the content for your reminder',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  autofocus: true,
                  maxLines: 2,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? "Please enter reminder content"
                      : null,
                  onSaved: (input) => reminder = input?.trim(),
                  decoration: InputDecoration(
                    labelText: 'Reminder Content',
                    hintText: 'e.g., Take medicine, Team meeting, Lunch...',
                    prefixIcon: const Icon(
                      Icons.edit_note,
                      color: Color(0xFF2E7D32),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF2E7D32),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          reminder = null;
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Create',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(String? payload) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9500).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.notifications_active,
                  size: 40,
                  color: Color(0xFFFF9500),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Reminder Alert',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  payload ?? "No content available",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF374151),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9500),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Got it!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Item> _genItems(List a) {
    return List.generate(
      a.length,
      (i) => Item(
        id: a[i][3],
        headerValue: a[i][4],
        expandedValue:
            "${a[i][0].day}/${a[i][0].month}/${a[i][0].year} ${a[i][1].format(context)}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Reminders",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        centerTitle: true,
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2E7D32),
          borderRadius: BorderRadius.circular(16),
        ),
        child: FloatingActionButton(
          onPressed: () => pickDate(context, null),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: reminders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "No Reminders Yet",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tap the + button to create your first reminder",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            )
          : Container(
              color: const Color(0xFFF5F7FA),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final item = reminders[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.schedule,
                          color: Color(0xFF2E7D32),
                          size: 24,
                        ),
                      ),
                      title: Text(
                        item.headerValue,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.access_time,
                                      color: Colors.blue.shade600,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "Scheduled: ${item.expandedValue}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Delete button với style mới
                              Container(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Hủy Timer nếu đang chạy
                                    final timerId = item.id;
                                    if (activeTimers.containsKey(timerId)) {
                                      activeTimers[timerId]?.cancel();
                                      activeTimers.remove(timerId);
                                      print('✅ Đã hủy Timer với ID: $timerId');
                                    }

                                    // Hủy notification (phòng trường hợp)
                                    fltrNotification.cancel(timerId);

                                    setState(() {
                                      alarms.removeAt(index);
                                      reminders.removeAt(index);
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Reminder deleted successfully',
                                        ),
                                        backgroundColor: Color(0xFFEF4444),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                  ),
                                  label: const Text(
                                    'Delete Reminder',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEF4444),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class Item {
  Item({
    required this.id,
    required this.headerValue,
    required this.expandedValue,
  });

  int id;
  String headerValue;
  String expandedValue;
}
