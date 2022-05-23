import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motivational_quotes/Quotes.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Quotes>> getAllQuotes() async {
    final response = await http
        .get(Uri.parse("https://jsonguide.technologychannel.org/quotes.json"));
    var jsonData = jsonDecode(response.body);
    List<Quotes> allQuotes = [];

    for (var q in jsonData) {
      allQuotes.add(Quotes(text: q["text"], from: q["from"]));
    }
    return allQuotes;
  }

  @override
  void initState() {
    super.initState();
    getAllQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Motivational Quotes',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Quotes>>(
          future: getAllQuotes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (ctx, i) {
                    return Card(
                      elevation: 6,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text((i + 1).toString()),
                        ),
                        title: Text(snapshot.data![i].text),
                        subtitle: Text(snapshot.data![i].from),
                      ),
                    );
                  });
            }
            return const CircularProgressIndicator();
          }),
    );
  }
}
