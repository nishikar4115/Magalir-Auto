import 'dart:math';
import 'package:flutter/material.dart';

class LatLng {
  final double lat;
  final double lng;
  const LatLng(this.lat, this.lng);
}

class Driver {
  final String id;
  final String name;
  final String vehicle;
  final double rating;
  final LatLng location;
  final String phone;
  const Driver({
    required this.id,
    required this.name,
    required this.vehicle,
    required this.rating,
    required this.location,
    required this.phone,
  });
}

class HomeMapPlaceholder extends StatefulWidget {
  const HomeMapPlaceholder({Key? key}) : super(key: key);

  @override
  State<HomeMapPlaceholder> createState() => _HomeMapPlaceholderState();
}

class _HomeMapPlaceholderState extends State<HomeMapPlaceholder> {
  final Random _rnd = Random();

  final Map<String, LatLng> places = {
    'Select place': LatLng(0, 0),
    'Chennai Central': LatLng(13.0827, 80.2756),
    'Marina Beach': LatLng(13.0489, 80.2826),
    'T. Nagar': LatLng(13.0358, 80.2370),
    'Egmore': LatLng(13.0830, 80.2601),
    'Anna Nagar': LatLng(13.0823, 80.2108),
    'Adyar': LatLng(12.9915, 80.2510),
    'Guindy': LatLng(13.0109, 80.2210),
    'Velachery': LatLng(12.9868, 80.2251),
    'Kodambakkam': LatLng(13.0616, 80.2259),
    'Mylapore': LatLng(13.0199, 80.2700),
  };

  final List<Driver> drivers = [
    Driver(
        id: '1',
        name: 'Meena',
        vehicle: 'Auto - Pink',
        rating: 4.8,
        location: LatLng(13.0400, 80.2500),
        phone: '+91-9876543210'),
    Driver(
        id: '2',
        name: 'Radha',
        vehicle: 'Auto - Violet',
        rating: 4.9,
        location: LatLng(13.0700, 80.2700),
        phone: '+91-9876543211'),
    Driver(
        id: '3',
        name: 'Lakshmi',
        vehicle: 'Auto - Teal',
        rating: 4.7,
        location: LatLng(12.9950, 80.2300),
        phone: '+91-9876543212'),
    Driver(
        id: '4',
        name: 'Priya',
        vehicle: 'Auto - Rose Gold',
        rating: 4.6,
        location: LatLng(13.0100, 80.2050),
        phone: '+91-9876543213'),
    Driver(
        id: '5',
        name: 'Sneha',
        vehicle: 'Auto - Coral',
        rating: 4.8,
        location: LatLng(13.0500, 80.2400),
        phone: '+91-9876543214'),
    Driver(
        id: '6',
        name: 'Anitha',
        vehicle: 'Auto - Blue Pink',
        rating: 4.6,
        location: LatLng(13.0200, 80.2600),
        phone: '+91-9876543215'),
    Driver(
        id: '7',
        name: 'Divya',
        vehicle: 'Auto - Yellow Pink',
        rating: 4.5,
        location: LatLng(13.0300, 80.2300),
        phone: '+91-9876543216'),
    Driver(
        id: '8',
        name: 'Shalini',
        vehicle: 'Auto - Magenta',
        rating: 4.9,
        location: LatLng(12.9900, 80.2400),
        phone: '+91-9876543217'),
  ];

  String pickup = 'Select place';
  String drop = 'Select place';

  double? _distanceKm;
  double? _fare;
  Color _fareColor = Colors.black;
  String? _fareLine;

  Driver? _selectedDriver;
  double? _driverDistanceKm;
  double? _etaMinutes;
  String? _driverLine;

  final double baseFare = 25.0;
  final double perKm = 10.0;
  final double perMin = 1.5;
  final double avgSpeedKmh = 25.0;

  final List<String> fareLines = [
    "Numbers ready — may your ride be bump-free! 🛺",
    "Fare served hot. Please hold your seat 😄",
    "Calculated with love and little math ❤️",
    "All set! Tip your auto if it sings 🎶",
    "We used our best calculator (and hope) 😄"
  ];

  final List<String> driverLines = [
    "Your driver is calm and punctual — smooth ride ahead ✨",
    "Expert in Chennai shortcuts — traffic can't stop her 😉",
    "Friendly driver incoming — enjoy the breeze 🌟",
    "Knows every lane like her playlist 🎧",
    "Perfect match — she’s on the way 🚗✨"
  ];

  double _d2r(double deg) => deg * (pi / 180);

  double distance(LatLng a, LatLng b) {
    final R = 6371.0;
    final dLat = _d2r(b.lat - a.lat);
    final dLon = _d2r(b.lng - a.lng);
    final x = sin(dLat / 2) * sin(dLat / 2) +
        cos(_d2r(a.lat)) * cos(_d2r(b.lat)) * sin(dLon / 2) * sin(dLon / 2);
    return R * 2 * atan2(sqrt(x), sqrt(1 - x));
  }

  void calculateFare() {
    if (pickup == 'Select place' || drop == 'Select place') return;
    final p = places[pickup]!;
    final d = places[drop]!;
    final km = distance(p, d);
    final mins = km * 2;
    final amount = baseFare + perKm * km + perMin * mins;
    setState(() {
      _distanceKm = km;
      _fare = amount.ceilToDouble();
      _fareColor = Colors.primaries[_rnd.nextInt(Colors.primaries.length)];
      _fareLine = fareLines[_rnd.nextInt(fareLines.length)];
      _selectedDriver = null;
      _driverDistanceKm = null;
      _etaMinutes = null;
      _driverLine = null;
    });
  }

  void findDriver() {
    if (pickup == 'Select place') return;
    final p = places[pickup]!;
    Driver? best;
    double? bestDist;
    for (var d in drivers) {
      final dist = distance(p, d.location);
      if (best == null || dist < bestDist!) {
        best = d;
        bestDist = dist;
      }
    }
    if (best != null) {
      final eta = (bestDist! / avgSpeedKmh) * 60;
      setState(() {
        _selectedDriver = best;
        _driverDistanceKm = bestDist;
        _etaMinutes = eta;
        _driverLine = driverLines[_rnd.nextInt(driverLines.length)];
      });
    }
  }

  void acceptDriver() {
    if (_selectedDriver == null) return;
    final m = _etaMinutes!.ceil();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_selectedDriver!.name} arriving in ~$m min')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = places.keys
        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Magalir Auto — Passenger"),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text("Map Placeholder",
                    style: TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("Pickup:"),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField(
                    value: pickup,
                    items: items,
                    onChanged: (v) => setState(() => pickup = v!),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), isDense: true),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Drop:"),
                const SizedBox(width: 24),
                Expanded(
                  child: DropdownButtonFormField(
                    value: drop,
                    items: items,
                    onChanged: (v) => setState(() => drop = v!),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), isDense: true),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: calculateFare,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink),
                        child: const Text("Calculate Fare"))),
                const SizedBox(width: 10),
                Expanded(
                    child: ElevatedButton(
                        onPressed: findDriver,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: const Text("Find Driver"))),
              ],
            ),
            const SizedBox(height: 10),
            if (_fare != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Distance: ${_distanceKm!.toStringAsFixed(2)} km"),
                    const SizedBox(height: 6),
                    Text("Estimated Fare: ₹${_fare!.toStringAsFixed(0)}",
                        style: TextStyle(
                            color: _fareColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(_fareLine!,
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: _fareColor))
                  ],
                ),
              ),
            if (_selectedDriver != null) ...[
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.pink,
                        child: Text(
                          _selectedDriver!.name[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_selectedDriver!.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              "${_selectedDriver!.vehicle} • ${_selectedDriver!.rating} ⭐"),
                          Text(
                              "Distance: ${_driverDistanceKm!.toStringAsFixed(2)} km"),
                          Text("ETA: ${_etaMinutes!.ceil()} min"),
                          const SizedBox(height: 6),
                          Text(_driverLine!,
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      )),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon:
                                  const Icon(Icons.call, color: Colors.green)),
                          ElevatedButton(
                              onPressed: acceptDriver,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange),
                              child: const Text("Accept"))
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Drivers: ${drivers.length}",
                    style: const TextStyle(color: Colors.grey)),
                const Text("v1.0", style: TextStyle(color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// lib/login_screen.dart
import 'package:flutter/material.dart';
import 'home_map_placeholder.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController otpController = TextEditingController();

  String fakeOTP = "1234";
  bool showOTP = false;
  String errorText = "";

  void sendOTP() {
    String phone = phoneController.text.trim();

    if (phone.length != 10) {
      setState(() {
        errorText = "Phone number must be exactly 10 digits";
      });
      return;
    }

    setState(() {
      errorText = "";
      showOTP = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Fake OTP is: $fakeOTP")),
    );
  }

  void verifyOTP() {
    if (otpController.text == fakeOTP) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeMapPlaceholder()),
      );
    } else {
      setState(() {
        errorText = "Invalid OTP";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFC0CB), // baby pink

      appBar: AppBar(
        title: const Text('Magalir Auto'),
        backgroundColor: Color(0xFFFF5C8A),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter phone number',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintText: 'Enter 10 digit phone number',
                ),
              ),
              const SizedBox(height: 10),
              if (showOTP)
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'Enter OTP',
                  ),
                ),
              const SizedBox(height: 10),
              if (errorText.isNotEmpty)
                Text(
                  errorText,
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: showOTP ? verifyOTP : sendOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF5C8A),
                ),
                child: Text(showOTP ? "Verify OTP" : "Send OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const MagalirAutoApp());
}

class MagalirAutoApp extends StatelessWidget {
  const MagalirAutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magalir Auto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: LoginScreen(), // remove const here if error shows
    );
  }
}
