import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivateNotePage extends StatefulWidget {
  const PrivateNotePage({Key? key}) : super(key: key);

  @override
  _PrivateNotePageState createState() => _PrivateNotePageState();
}

class _PrivateNotePageState extends State<PrivateNotePage> {
  List<String> titles = [];
  List<String> memos = [];

  @override void initState() {
    super.initState();
    _loadNotes();
  }

  _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      titles = prefs.getStringList('titles') ?? [];
      memos = prefs.getStringList('memos') ?? [];
    });

  }

  _saveMemos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('titles', titles);
    prefs.setStringList('memos', memos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Private Note'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: memos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              titles.length > index ? titles[index] : '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            subtitle: Text(
              memos.length > index ? memos[index] : '',
              style: const TextStyle(fontSize: 14.0),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  titles.removeAt(index);
                  memos.removeAt(index);
                  _saveMemos();
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMemoDialog(context);
        },
        tooltip: 'Create Private Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMemoDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController memoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Private Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: memoController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                ),
                maxLines: null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  titles.add(titleController.text);
                  memos.add(memoController.text);
                  _saveMemos();
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
