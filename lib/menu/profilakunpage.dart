import 'package:flutter/material.dart';

class ProfilAkunPage extends StatefulWidget {
  const ProfilAkunPage({Key? key}) : super(key: key);

  @override
  State<ProfilAkunPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<ProfilAkunPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Akun'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage('assets/profile.png'), // Profil Image
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField('Nama Lengkap', 'Ilhammm'),
              const SizedBox(height: 20),
              _buildTextField('NIK', '3512395710297312'),
              const SizedBox(height: 20),
              _buildTextField('Jenis Kelamin', 'Laki - Laki'),
              const SizedBox(height: 20),
              _buildTextField('No Hp', '0813451239120'),
              const SizedBox(height: 20),
              _buildTextField('Alamat Lengkap', 'Nganjuk, Bogo'),
              const SizedBox(height: 20),
              _buildTextField('Jumlah GH', '3'),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildButton(context, 'Edit', const ProfilAkunPage()),
                  buildButton(context, 'Ubah Password',
                      const ProfilAkunPage()), // Halaman Page yang akan dituju
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          enabled: false, // Agar tidak bisa untuk diedit
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget buildButton(BuildContext context, String text, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: 331, // Lebar tombol
        height: 52, // Tinggi tombol
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD8A37E), // Warna tombol D8A37E
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10), // Membuat tombol melengkung
            ),
            textStyle: const TextStyle(
                color: Colors.white), // Menambahkan warna teks putih
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 18, color: Colors.white), // Teks putih
          ),
        ),
      ),
    );
  }
}
