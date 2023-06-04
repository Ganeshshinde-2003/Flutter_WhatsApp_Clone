import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/Colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneController.dispose();
  }
  void pickCountry() {
    showCountryPicker(context: context, onSelect: (Country _country){
      setState(() {
        country = _country;
      });
    });
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text("Enter your phone number"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Whatsapp will need to verify your phone number."),
            const SizedBox(height: 10,),
            TextButton(onPressed: pickCountry, child: Text("Pick Country")),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(country != null)
                  Text("+${country!.phoneCode}"),
                const SizedBox(width: 10,),
                SizedBox(width: size.width*0.7,
                child: TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    hintText: "phone number",
                  ),
                )
                  ,),
              ],
            ),
            SizedBox(height: size.height*0.6,), 
            SizedBox(
              width: 90,
              child: CustomButton(
                onPressed: (){},
                text: "NEXT",
              ),
            )
          ],
        ),
      ),
    );
  }
}
