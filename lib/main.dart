import 'package:flutter/material.dart';  
import 'package:http/http.dart' as http;  
import 'dart:convert';  
import 'package:logger/logger.dart'; 

final Logger logger = Logger();  

void main() {
  runApp(const MyApp());  
}

class MyApp extends StatelessWidget {  
  const MyApp({super.key});  // Constructor for MyApp

  @override
  Widget build(BuildContext context) {  // Build method for the widget
    return MaterialApp(  
      title: 'Age Estimation App', 
      theme: ThemeData(  
        primarySwatch: Colors.blue,  
      ),
      home: const AgeEstimationScreen(),  
    );
  }
}

class AgeEstimationScreen extends StatefulWidget {  
  const AgeEstimationScreen({super.key});  // Constructor for AgeEstimationScreen

  @override
  _AgeEstimationScreenState createState() => _AgeEstimationScreenState();  
}

class _AgeEstimationScreenState extends State<AgeEstimationScreen> {  
  String name = '';  // Initialize a new string variable called name
  int estimatedAge = 0;  // Initialize a new integer variable called estimatedAge

  Future<void> getEstimatedAge() async {  // Asynchronous method to get the estimated age
    final String apiUrl = 'https://api.agify.io/?name=$name';  // Define the API URL

    try {
      final response = await http.get(Uri.parse(apiUrl));  // Send a get request to the API

      if (response.statusCode == 200) {  // If the response is successful
        final Map<String, dynamic> data = jsonDecode(response.body);  // Decode the response body

        setState(() {  // Update the state
          estimatedAge = data['age'] ?? 0;  // Set the estimatedAge variable
        });
      } else {
        setState(() {  // Update the state
          estimatedAge = 0;  // Set the estimatedAge variable to 0
        });
      }
    } catch (error) {
      logger.e('Error: $error');  // Log the error
      setState(() {  // Update the state
        estimatedAge = 0;  
      });
    }
  }

  @override
  Widget build(BuildContext context) {  // Build method for the widget
    return Scaffold(  // Return a new Scaffold widget
      appBar: AppBar(  // Set the app bar
        title: const Text('Age Estimation'),  // Set the title of the app bar
      ),
      body: Container(  // Set the body of the scaffold to a new container
        decoration: const BoxDecoration(  // Set the decoration of the container
          image: DecorationImage(  
            image: NetworkImage(  
              'https://images.crystalbridges.org/uploads/2015/11/Chaplin-The-Kid.jpg?_gl=1*842f1e*_gcl_au*NzYwMzgwMDAuMTcwMjAzODk0Mw..'),  // Set the image URL
            fit: BoxFit.cover,  // Set the fit of the image
          ),
        ),
        child: Padding(  
          padding: const EdgeInsets.all(16.0),  
          child: Column(  
            mainAxisAlignment: MainAxisAlignment.end,  
            crossAxisAlignment: CrossAxisAlignment.center,  
            children: [  // Set the children of the column
              TextField(  
                onChanged: (value) {  // Set the onChanged callback
                  setState(() {  // Update the state
                    name = value;  // Set the name variable
                  });
                },
                decoration: const InputDecoration(  
                  hintText: 'Enter a name',  
                  filled: true,  
                  fillColor: Colors.white,  
                ),
              ),
              const SizedBox(height: 16),  
              ElevatedButton(  
                onPressed: () {  // Set the on pressed callback
                  getEstimatedAge();  // Call the getEstimatedAge method
                },
                style: ElevatedButton.styleFrom(  
                  foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,  
                  elevation: 5,  
                ),
                child: const Text('Estimate Age'),  
              ),
              const SizedBox(height: 16),  
              if (name.isNotEmpty && estimatedAge > 0)  
                Text(  // Add a new text widget
                  'The estimated age is $estimatedAge',  
                  style: const TextStyle( 
                    color: Color.fromARGB(255, 186, 233, 14),  
                    fontSize: 28,  
                  ),
                ),
              const SizedBox(height: 16),  
            ],
          ),
        ),
      ),
    );
  }
}