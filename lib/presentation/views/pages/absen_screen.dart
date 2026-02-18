import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sidak_desa_mobile/core/const/app_colors.dart';
import '../../controllers/absen_controller.dart';

class AbsenScreen extends StatelessWidget {
  const AbsenScreen({super.key, required this.qrData});

  final Map<String, dynamic> qrData;

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AbsenController(qrData: qrData));
    return Scaffold(
      appBar: AppBar(title: const Text('Absen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text("Nama", style: TextStyle(fontSize: 14)),
              const SizedBox(height: 5),
              Text(
                c.user.value?.name ?? '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Divider(),

              Text("Jabatan", style: TextStyle(fontSize: 14)),
              const SizedBox(height: 5),
              Text(
                c.user.value?.jabatan ?? '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Divider(),
              Text("Jenis Kelamin", style: TextStyle(fontSize: 14)),
              const SizedBox(height: 5),
              Text(
                c.user.value?.jenisKelamin ?? '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Divider(),

              Text("Alamat", style: TextStyle(fontSize: 14)),
              const SizedBox(height: 5),
              Text(
                c.user.value?.address ?? '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Divider(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Absen Masuk", style: TextStyle(fontSize: 14)),
                      Obx(
                        () => Text(
                          c.isLoadingDaily.value ? '...' : c.checkInText,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Absen Keluar",
                        style: TextStyle(fontSize: 14),
                      ),
                      Obx(
                        () => Text(
                          c.isLoadingDaily.value ? '...' : c.checkOutText,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Lokasi Terkini',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: c.isLoadingLocation.value
                        ? null
                        : c.getCurrentLocation,
                    icon: const Icon(Icons.my_location),
                  ),
                ],
              ),
              Obx(() {
                if (c.isLoadingLocation.value) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text('Mengambil lokasi...'),
                  );
                }

                if (c.locationError.value != null) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      c.locationError.value!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final lat = c.latitude.value;
                final lng = c.longitude.value;
                if (lat == null || lng == null) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text('-'),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                );
              }),
              Obx(() {
                final lat = c.latitude.value;
                final lng = c.longitude.value;
                if (lat == null || lng == null) {
                  return Container(
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200,
                    ),
                    child: const Text('Peta akan tampil setelah lokasi didapatkan'),
                  );
                }

                return SizedBox(
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(lat, lng),
                        initialZoom: 16,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.sidakdesa.mobile',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(lat, lng),
                              width: 44,
                              height: 44,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: c.isSubmitting.value ? null : c.submitAbsen,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(55),
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: c.isSubmitting.value
                        ? const Text(
                            'Memproses...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text(
                            'Absen',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
