import 'dart:convert';
//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List students = [];
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchStudent();
  }

  fetchStudent() async {
    setState(() {
      isloading = true;
    });
    String url = "https://hp-api.herokuapp.com/api/characters/students";
    var response = await http.get(Uri.parse(url));
    //print(response.body);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      //print(items);
      setState(() {
        students = items;
        isloading = false;
      });
    } else {
      setState(() {
        students = [];
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Hogwarts Students List")),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (students.contains(null) || students.isEmpty || isloading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
      ));
    }

    return ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return getCard(students[index]);
        });
  }

  Widget getCard(item) {
    var fullname = item['name'];
    var DoB = item['dateOfBirth'];
    var profileUrl = item['image'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          trailing: Icon(Icons.arrow_forward),
          title: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(profileUrl.toString()))),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(fullname.toString(), style: TextStyle(fontSize: 17)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(DoB.toString(),
                      style: TextStyle(fontSize: 17, color: Colors.grey)),
                ],
              )
            ],
          ),
          onTap: () {
            Navigator.push(this.context,
                MaterialPageRoute(builder: (context) => DetailPage()));
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello world"),
      ),
    );
  }
}
