import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TripDetail extends StatefulWidget {
  final Map trip;
  const TripDetail({super.key, required this.trip});

  @override
  State<TripDetail> createState() => _TripDetailState();
}

class _TripDetailState extends State<TripDetail> {
  List destinations = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    destinations = widget.trip['destinations'] ?? [];
  }

  Future<void> addDestinationToTrip() async {
    final url = Uri.parse(
      'http://40.40.5.15:3000/trips/${widget.trip['_id']}',
    );
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': nameController.text,
        'date': dateController.text,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        destinations.add({
          'name': nameController.text,
          'date': dateController.text,
        });
        nameController.clear();
        dateController.clear();
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menambahkan destinasi")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;

    return Scaffold(
      appBar: AppBar(
        title: Text(trip['title']),
        backgroundColor: Color.fromARGB(255, 34, 102, 141),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Periode: ${trip['startDate']} - ${trip['endDate']}",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            Text("Destinasi:", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Expanded(
              child:
                  destinations.isEmpty
                      ? Text("Belum ada destinasi")
                      : ListView.builder(
                        itemCount: destinations.length,
                        itemBuilder: (context, index) {
                          final d = destinations[index];
                          return ListTile(
                            leading: Icon(Icons.place),
                            title: Text(d['name']),
                            subtitle: Text("Tanggal: ${d['date']}"),
                          );
                        },
                      ),
            ),
            Divider(),
            Text("Tambah Destinasi ke Trip Ini"),
            SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Nama Tempat",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: "Tanggal (YYYY-MM-DD)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addDestinationToTrip,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 45),
              ),
              child: Text(
                "Tambah Destinasi",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
