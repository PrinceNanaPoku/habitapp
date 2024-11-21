import 'package:flutter/material.dart';
import 'package:habitapp/model/app_settings.dart';
import 'package:habitapp/model/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  /*
SETUP
  */

  //INITIALIZE DATABASE
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar =
        await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }

  //Save first date of app startup
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //Get first date of app settings
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /*
  CRUD OPERATIONS
  */

  //List of habits
  List<Habit> currentHabits = [];

  //Create - add new habits
  Future<void> newHabit(String habitName) async {
    //create new habit
    final newHabit = Habit()..name = habitName;

    //save new habit
    await isar.writeTxn(() => isar.habits.put(newHabit));

    //re-read habit
    readHabits();
  }

  //Read - read saved habits from db
  Future<void> readHabits() async {
    //fetch all habits from db
    List<Habit> fetchHabits = await isar.habits.where().findAll();
    //give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchHabits);

    //update UI
    notifyListeners();
  }

  //Update - check habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);

    //update completion status
    if (habit != null) {
      await isar.writeTxn(
        () async {
          if (isCompleted && !habit.completeDays.contains(DateTime.now())) {
////today
            final today = DateTime.now();

            //add the current day if it's not already in the list
            habit.completeDays.add(
              DateTime(
                today.year,
                today.month,
                today.day,
              ),
            );
            //if habit is not completed then remove current date
          } else {
            //remove the current date when the habit is marked as uncompleted
            habit.completeDays.removeWhere(
              (date) =>
                  date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day,
            );
          }
          //save the updated habits back to db
          await isar.habits.put(habit);
        },
      );
    }
    //re-read from database
    readHabits();
  }

  //Update - edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    //find the specific name
    final habit = await isar.habits.get(id);

    //update habit name
    if (habit != null) {
      //update name
      await isar.writeTxn(() async {
        habit.name = newName;

        //update name in db
        await isar.habits.put(habit);
      });
    }

    //re-read from database
    readHabits();
  }

  //Delete - delete habit
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(
      () async => await isar.habits.delete(id),
    );
    //re-read from db
    readHabits();
  }
}
