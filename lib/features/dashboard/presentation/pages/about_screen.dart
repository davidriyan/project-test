// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/text_style.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tentang',
          style: greyTextstyle.copyWith(
            fontSize: 16,
            fontWeight: medium,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: size.height * 0.2,
              width: size.width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.greyColors,
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/foto_me.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nama : ',
                  style: greyTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: medium,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'David Riyan Kurniawan',
                  style: greyTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Posisi : ',
                  style: greyTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: medium,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Mobile Developer',
                  style: greyTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.25),
            Container(
              height: size.height * 0.05,
              width: size.width * 0.3,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(100),
              ),
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Berhasil Logout'),
                    ),
                  );
                  print('berhasil Logout');
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(
                    'Logout',
                    textAlign: TextAlign.center,
                    style: whiteTextstyle.copyWith(
                      fontSize: 15,
                      fontWeight: bold,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              '\u00A9 Copyright David Riyan Kurniawan',
              style: greyTextstyle.copyWith(
                fontSize: 14,
                fontWeight: bold,
              ),
            ),
            const SizedBox(height: 5)
          ],
        ),
      ),
    );
  }
}
