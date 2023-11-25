import 'dart:convert';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<Map<String, dynamic>> fetchRandomJoke() async {
    final response = await http
        .get(Uri.parse('https://official-joke-api.appspot.com/random_joke'));

       if(response.statusCode == 200) {
         final data = json.decode(response.body);
         return data;
       } else {
        throw Exception('Failed to fetch a random joke');
       }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text('Random Joke'),
          centerTitle: true,
        ),
        body: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
            child: FutureBuilder(
              future: fetchRandomJoke(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if(snapshot.hasData) {
                  final joke = snapshot.data;
                  final setup = joke!['setup'];
                  final punchline = joke['punchline'];

                return  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     FlipCard(
                        front: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text('Joke',
                                  style: TextStyle(
                                    fontSize:20 
                                  ),
                                ),
                                SizedBox(height: 15,),
                                Text('$setup', 
                                  style: TextStyle(
                                      fontSize: 17
                                ),
                              ),
                              ],
                            ),
                          ),
                        ),
                       
                        back: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text('Punchline',
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                ),
                                SizedBox(height: 15,),
                                Text('$punchline', 
                                  style: TextStyle(
                                    fontSize: 17
                                ),
                              ),
                              ],
                            ),
                          ),
                        ),
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(
                        onPressed: (){
                          setState(() {
                            fetchRandomJoke();
                          });
                        },
                        child: Text('Generate a random Joke'),
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                        ), 
                    
                    )
                    
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            
          },
        ),
        )
        ]
      )
    );
  }
}