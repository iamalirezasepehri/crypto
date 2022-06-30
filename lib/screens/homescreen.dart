import 'package:crypto/constant/constants.dart';
import 'package:crypto/data/classdata.dart';
import 'package:crypto/screens/resultpage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('images/logo.png'),
            ),
            SpinKitWave(
              color: Colors.white,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getdata() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<crypto> cryptolist = response.data['data']
        .map<crypto>((fromobject) => crypto.frommap(fromobject))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ResultPage(cryptoc: cryptolist);
        },
      ),
    );
  }
}
