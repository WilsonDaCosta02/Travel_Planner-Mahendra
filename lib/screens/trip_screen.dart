import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_trip.dart';
import 'trip_detail.dart'; // ← tambahkan ini

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  List trips = [];

  @override
  void initState() {
    super.initState();
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    final url = Uri.parse('http://192.168.1.95:3000/trips');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        trips = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat daftar trip")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Trip'),
        backgroundColor: Color.fromARGB(255, 34, 102, 141),
      ),
      body:
          trips.isEmpty
              ? Center(child: Text('Belum ada trip'))
              : ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(trip['title']),
                      subtitle: Text(
                        'Dari: ${trip['startDate']}  -  Sampai: ${trip['endDate']}',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripDetail(trip: trip),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTrip()),
          );
          fetchTrips(); // refresh setelah tambah trip
        },
      ),
    );
  }
}
