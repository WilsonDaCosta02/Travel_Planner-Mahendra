import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_destination.dart';
import 'package:google_fonts/google_fonts.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key});

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  List destinations = [];

  @override
  void initState() {
    super.initState();
    fetchDestinations();
  }

  Future<void> fetchDestinations() async {
    final url = Uri.parse('http://192.168.18.191:3000/destinations');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        destinations = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal memuat destinasi")));
    }
  }

  Future<void> deleteDestination(String id) async {
    final url = Uri.parse('http://40.40.5.15:3000/destinations/$id');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      fetchDestinations();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menghapus destinasi")),
      );
    }
  }

  Future<void> editDestination(String id, String name, String date) async {
    final url = Uri.parse('http://40.40.5.15:3000/destinations/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'date': date}),
    );
    if (response.statusCode == 200) {
      fetchDestinations();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal mengedit destinasi")));
    }
  }

  void showEditDialog(Map destination) {
    final nameController = TextEditingController(text: destination['name']);
    final dateController = TextEditingController(text: destination['date']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFEF8DC),
          title: Text(
            'Edit Destinasi',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF225B75),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  hintText: 'Nama Tempat',
                  hintStyle: GoogleFonts.poppins(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dateController,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  hintText: 'Tanggal',
                  hintStyle: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Batal', style: GoogleFonts.poppins()),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF225B75),
              ),
              child: Text(
                'Simpan',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
                editDestination(
                  destination['_id'],
                  nameController.text,
                  dateController.text,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmation(String id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFFFEF8DC),
            title: Text(
              'Hapus Destinasi?',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF225B75),
              ),
            ),
            content: Text(
              'Kamu yakin ingin menghapus destinasi ini?',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                child: Text('Batal', style: GoogleFonts.poppins()),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF225B75),
                ),
                child: Text(
                  'Hapus',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  deleteDestination(id);
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8DC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF8DC),
        elevation: 0,
        title: Text(
          'List Destinasimu',
          style: GoogleFonts.poppins(
            color: const Color(0xFF225B75),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body:
          destinations.isEmpty
              ? Center(
                child: Text(
                  'Belum ada destinasi',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF225B75),
                  ),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final destination = destinations[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF8DC),
                      border: Border.all(color: const Color(0xFF225B75)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 32,
                          color: Color(0xFF225B75),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          destination['name'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF225B75),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          destination['date'],
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF225B75),
                          ),
                        ),
                        const SizedBox(height: 8),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Color(0xFF225B75),
                          ),
                          onSelected: (value) {
                            if (value == 'edit') {
                              showEditDialog(destination);
                            } else if (value == 'delete') {
                              showDeleteConfirmation(destination['_id']);
                            }
                          },
                          itemBuilder:
                              (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text(
                                    'Edit',
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text(
                                    'Hapus',
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF225B75),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDestination()),
          );
          fetchDestinations();
        },
      ),
    );
  }
}
