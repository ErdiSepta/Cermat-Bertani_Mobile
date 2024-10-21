import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart';
import 'package:apps/src/customColor.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilAkunPage extends StatefulWidget {
  const ProfilAkunPage({super.key});

  @override
  State<ProfilAkunPage> createState() => _ProfilAkunPageState();
}

class _ProfilAkunPageState extends State<ProfilAkunPage> {
  bool _isEditing = false;
  final Map<String, TextEditingController> _controllers = {};
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _controllers['Nama Lengkap'] = TextEditingController(text: 'Ilhammm');
    _controllers['NIK'] = TextEditingController(text: '3512395710297312');
    _controllers['Jenis Kelamin'] = TextEditingController(text: 'Laki - Laki');
    _controllers['No Hp'] = TextEditingController(text: '081345123120');
    _controllers['Alamat Lengkap'] = TextEditingController(text: 'Nganjuk, Bogo');
    _controllers['Jumlah GH'] = TextEditingController(text: '3');
  }

  Future<void> getImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Topnav(
          title: 'Akun',
          showBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: _image != null
                            ? Image.file(
                                _image!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/fufufafa.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: getImage,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: CustomColors.coklatMedium,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ..._controllers.entries.map((e) => buildTextField(e.key, e.value)),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.coklatMedium,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                        });
                      },
                      child: Text(
                        _isEditing ? 'Selesai' : 'Edit',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'NotoSan',
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD8A37E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      onPressed: _isEditing ? () {
                        // Implementasi fungsi save
                        setState(() {
                          _isEditing = false;
                        });
                      } : null,
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'NotoSan',
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontFamily: 'NotoSan'
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            readOnly: !_isEditing,
            decoration: InputDecoration(
              hintText: controller.text,
              hintStyle: const TextStyle(color: Colors.black),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 12.0
              ),
            ),
          ),
        ],
      ),
    );
  }
}
