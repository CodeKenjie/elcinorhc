import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static const String _channelId = 'task_reminders';
  static const String _channelName = 'Task Reminders';
  static const String _channelDescription = 'Notifications for upcoming and due task';

  Future<void> init() async {
    tz.initializeTimeZones();

    final timezone = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(timezone.identifier));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings
    );

    await _notifications.initialize(settings: settings);

    await _requestPermission();

    const androidChannel = AndroidNotificationChannel(
      _channelId, 
      _channelName,
      description: _channelDescription,
      importance: Importance.high
    );

    await _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidChannel);
  }

  Future<void> _requestPermission() async {
    await _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true
    );

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();
  }

  Future<void> scheduleTaskNotifications({
    required int todoId,
    required String title,
    DateTime? startsAt,
    DateTime? endsAt,
    DateTime? expiresAt
  }) async {
    await cancelTaskNotifications(todoId);

    final now = tz.TZDateTime.now(tz.local);

    if(startsAt != null) {
      final startTime = tz.TZDateTime.from(startsAt, tz.local);
      final thirtyMinutesBefore = startTime.subtract(const Duration(minutes: 30));
      final fiveMinuteBefore = startTime.subtract(const Duration(minutes: 5));

      if(thirtyMinutesBefore.isAfter(now)) {
        await _scheduleNotification(
          id: _startThirtyMinutesId(todoId), 
          title: 'Task will start soon.', 
          body: '$title is starting in 30 minutes.', 
          scheduledTime: thirtyMinutesBefore
        );
      }

      if(fiveMinuteBefore.isAfter(now)) {
        await _scheduleNotification(
          id: _startFiveMinutesId(todoId), 
          title: 'Task is starting soon.', 
          body: '$title is starting in 5 minutes.', 
          scheduledTime: fiveMinuteBefore
        );
      }

      if(startTime.isAfter(now)) {
        await _scheduleNotification(
          id: _startNowId(todoId), 
          title: 'Task is starting now.', 
          body: '$title starts now.', 
          scheduledTime: startTime
        );
      }
    }

    if(endsAt != null) {
      final endTime = tz.TZDateTime.from(endsAt, tz.local);
      final thirtyMinutesBefore = endTime.subtract(const Duration(minutes: 30));
      final fiveMinuteBefore = endTime.subtract(const Duration(minutes: 5));

      if(thirtyMinutesBefore.isAfter(now)) {
        await _scheduleNotification(
          id: _endThirtyMinutesId(todoId), 
          title: 'Task will end soon.', 
          body: '$title is ending in 30 minutes.', 
          scheduledTime: thirtyMinutesBefore
        );
      }

      if(fiveMinuteBefore.isAfter(now)) {
        await _scheduleNotification(
          id: _endFiveMinutesId(todoId), 
          title: 'Task is ending soon.', 
          body: '$title is ending in 5 minutes.', 
          scheduledTime: fiveMinuteBefore
        );
      }

      if(endTime.isAfter(now)) {
        await _scheduleNotification(
          id: _endNowId(todoId), 
          title: 'Task ended.', 
          body: '$title has ended.', 
          scheduledTime: endTime
        );
      }
    }

    if(expiresAt != null) {
      final expiresToday = tz.TZDateTime(tz.local, expiresAt.year, expiresAt.month, expiresAt.day, 8, 0);

      if(expiresToday.isAfter(now)) {
        await _scheduleNotification(
          id: _expiresTodayId(todoId), 
          title: 'Task expires today.', 
          body: '$title expires today. Make sure to finish it.', 
          scheduledTime: expiresToday
        );
      }
    }
  }

  Future<void> schedulePlanNotification({
    required int planId,
    required String title,
    required DateTime dueAt,
  }) async {
    await cancelPlanNotifications(planId);
    final now = tz.TZDateTime.now(tz.local);
    final dueToday = tz.TZDateTime(tz.local, dueAt.year, dueAt.month, dueAt.day, 8, 0);

    if(dueToday.isAfter(now)){
      await _scheduleNotification(
        id: _dueTodayId(planId), 
        title: 'Your plan due is today.', 
        body: '$title due is today. Make sure that all task is complete.', 
        scheduledTime: dueToday
      );
    }
  }

  Future<void> dailyJournalReminder() async {
    await cancelDailyJournalReminder();
    final now = tz.TZDateTime.now(tz.local);

    var reminderTime = tz.TZDateTime(
      tz.local, 
      now.year,
      now.month,
      now.day,
      20,
      0
    );

    if(!reminderTime.isAfter(now)) {
      reminderTime = reminderTime.add(const Duration(days: 1));
    }

    await _scheduleNotification(
      id: _dailyJournalReminderId,
      title: "Time to take a journal.",
      body: "Take time to take a journal today.",
      scheduledTime: reminderTime,
      daily: true
    );
  }

  Future<void> cancelDailyJournalReminder() async {
    await _notifications.cancel(id: _dailyJournalReminderId);
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
    bool daily = false
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId, 
      _channelName,
      importance: Importance.high,
      priority: Priority.high
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true
    );

    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.zonedSchedule(
      id: id, 
      title: title,
      body: body,
      scheduledDate: scheduledTime, 
      notificationDetails: details, 
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: daily ? DateTimeComponents.time : null
    );
  }

  Future<void> cancelTaskNotifications(int todoId) async {
    await _notifications.cancel(id: _startThirtyMinutesId(todoId));
    await _notifications.cancel(id: _startFiveMinutesId(todoId));
    await _notifications.cancel(id: _startNowId(todoId));
    await _notifications.cancel(id: _endThirtyMinutesId(todoId));
    await _notifications.cancel(id: _endFiveMinutesId(todoId));
    await _notifications.cancel(id: _endNowId(todoId));
    await _notifications.cancel(id: _expiresTodayId(todoId));
  }

  Future<void> cancelPlanNotifications(int planId) async {
    await _notifications.cancel(id: _dueTodayId(planId));
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static const int _dailyJournalReminderId = 4001;

  int _startThirtyMinutesId(int todoId) {
    return 1000 + todoId * 10 + 1;
  }

  int _startFiveMinutesId(int todoId) {
    return 1000 + todoId * 10 + 2;
  }

  int _startNowId(int todoId) {
    return 1000 + todoId * 10 + 3;
  }

  int _endThirtyMinutesId(int todoId) {
    return 1000 + todoId * 10 + 4;
  }

  int _endFiveMinutesId(int todoId) {
    return 1000 + todoId * 10 + 5;
  }

  int _endNowId(int todoId) {
    return 1000 + todoId * 10 + 6;
  }

  int _expiresTodayId(int todoId) {
    return 1000 + todoId * 10 + 7;
  }

  int _dueTodayId(int planId) {
    return 2000 + planId * 10 + 1;
  }
}