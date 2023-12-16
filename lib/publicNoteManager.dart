import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'note.dart';

class PublicNotePage extends StatelessWidget {
  // `final`: `let` in rust
  // `const`: `const` in rust
  final String baseUrl;

  PublicNotePage(this.baseUrl, {Key? key}) : super(key: key);

  // https://dart.dev/codelabs/async-await
  Future<List<Note>> getPublicNotes() async {
    final response = await http.get(Uri.parse('$baseUrl/memos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Note.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load public notes');
    }
  }

  Future<void> addPublicNote(String title, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/memos'),
      body: jsonEncode({'title': title, 'content': content}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add public note');
    }
  }

  Future<void> removePublicNote(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/memos/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to remove public note');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Public Note'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: getPublicNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator()
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Note> notes = snapshot.data as List<Note>;

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    notes[index].title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  subtitle: Text(
                    notes[index].content,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  // Add your delete logic here if needed
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNoteDialog(context);
        },
        tooltip: 'Create Note',
        child: Icon(Icons.add),
      ),
      // Add your add note button or other UI elements here
    );
  }

  Future<void> _showAddNoteDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Public Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the method to add the public note
                addPublicNote(titleController.text, contentController.text);

                // Close the dialog
                Navigator.pop(context);
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
