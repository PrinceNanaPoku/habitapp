import 'package:flutter/material.dart';
import 'package:habitapp/components/drawer.dart';
import 'package:habitapp/components/habit_tile.dart';
import 'package:habitapp/database/habit_database.dart';
import 'package:habitapp/model/habit.dart';
import 'package:provider/provider.dart';

import '../util/habit_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void iniState() {
    //read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  //Text controller
  final TextEditingController textController = TextEditingController();
//create new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Create New Habit',
          ),
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: () {
              //get the new habit name
              String newHabitName = textController.text;
              //save to db
              context.read<HabitDatabase>().newHabit(newHabitName);
              //pop box
              Navigator.pop(context);

              //clear controller
              textController.clear();
            },
            child: const Text('Save'),
          ),

          //cancel button
          MaterialButton(
            onPressed: () {
              //pop box
              Navigator.pop(context);
              //clear controller
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  //chech habit on or off
  void turnHabitOnOff(bool? value, Habit habit) {
    //update habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(
            habit.id,
            value,
          );
    }
  }

  //edit habit
  void editHabit(Habit habit) {
    //set controller to current habit name
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: () {
              //get the new habit name
              String newHabitName = textController.text;
              //save to db
              context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, newHabitName);
              //pop box
              Navigator.pop(context);

              //clear controller
              textController.clear();
            },
            child: const Text('Update'),
          ),

          //cancel button
          MaterialButton(
            onPressed: () {
              //pop box
              Navigator.pop(context);
              //clear controller
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  //delete habit
  void deleteHabit(Habit habit) {
    //set controller to current habit name
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          //delete button
          MaterialButton(
            onPressed: () {
              //save to db
              context.read<HabitDatabase>().deleteHabit(habit.id);
              //pop box
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),

          //cancel button
          MaterialButton(
            onPressed: () {
              //pop box
              Navigator.pop(context);
              //clear controller
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        elevation: 0,
        child: const Icon(Icons.add),
      ),
      body: _buildHabitList(),
    );
  }

  Widget _buildHabitList() {
    //habit db
    final habitDatabase = context.watch<HabitDatabase>();

    //current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    //return list for habit UI
    return ListView.builder(
        itemCount: currentHabits.length,
        itemBuilder: (context, index) {
          //get each individual habit
          final habit = currentHabits[index];
          //check if the habit is completed today
          bool isCompleted = isHabitCompletedToday(habit.completeDays);
          //return habit tile UI
          return MyHabitTile(
            isCompleted: isCompleted,
            text: habit.name,
            onChanged: (value) => turnHabitOnOff(value, habit),
            onEditPressed: (context) => editHabit(habit),
            onDeletePressed: (context) => deleteHabit(habit),
          );
        });
  }
}
