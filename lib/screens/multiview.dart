/*
 * This file is part of the Kosmos Client (https://github.com/lolocomotive/kosmos_client)
 *
 * Copyright (C) 2022 lolocomotive
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:kosmos_client/screens/timetable.dart';
import 'package:kosmos_client/widgets/user_info.dart';

import '../kdecole-api/database_manager.dart';
import '../main.dart';
import 'home.dart';
import 'messages.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => MainState();
}

class MainState extends State<Main> {
  int _currentIndex = 0;

  MainState();

  _updateMessages() {
    DatabaseManager.fetchMessageData();
  }

  _updateNews() {
    DatabaseManager.fetchNewsData();
  }

  _updateTimetable() {
    DatabaseManager.fetchTimetable();
  }

  _closeDB() {
    Global.db!.close();
  }

  _clearDatabase() {
    Global.db!.delete('NewsArticles');
    Global.db!.delete('NewsAttachments');
    Global.db!.delete('Conversations');
    Global.db!.delete('Messages');
    Global.db!.delete('MessageAttachments');
    Global.db!.delete('Grades');
    Global.db!.delete('Lessons');
    Global.db!.delete('Exercises');
  }

  @override
  Widget build(BuildContext context) {
    Global.mainState = this;
    final Widget currentWidget;
    switch (_currentIndex) {
      case 0:
        currentWidget = const Home();
        break;
      case 1:
        currentWidget = const Messages();
        break;
      case 2:
        currentWidget = const Timetable();
        break;
      default:
        currentWidget = Debug();
    }

    if (currentWidget is! Messages) {
      Global.fab = null;
    }
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messagerie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Emploi du temps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bug_report),
            label: 'Debug',
          ),
        ],
        currentIndex: _currentIndex,
        unselectedItemColor: Colors.black45,
        unselectedFontSize: 12,
        selectedItemColor: Colors.black,
        selectedFontSize: 12,
        selectedIconTheme: const IconThemeData(size: 30),
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: currentWidget,
      floatingActionButton: Global.fab,
    );
  }

  Widget Debug() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
            onPressed: _updateMessages, child: const Text('Update messages')),
        ElevatedButton(
            onPressed: _updateNews, child: const Text('Update news')),
        ElevatedButton(
            onPressed: _updateTimetable, child: const Text('Update Timetable')),
        ElevatedButton(
            onPressed: _clearDatabase, child: const Text('Clear database')),
        ElevatedButton(
            onPressed: _closeDB, child: const Text('Close database')),
      ],
    );
  }
}
