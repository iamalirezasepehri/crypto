import 'package:crypto/constant/constants.dart';
import 'package:crypto/data/classdata.dart';
import 'package:crypto/screens/homescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  ResultPage({Key? key, this.cryptoc}) : super(key: key);
  List<crypto>? cryptoc;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<crypto>? cryptoc;
  bool showtextresult = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cryptoc = widget.cryptoc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackcolor,
      appBar: AppBar(
        title: Text(
          'کریپتو بازار',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'morabaee',
          ),
        ),
        centerTitle: true,
        backgroundColor: blackcolor,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    getresultsearch(value);
                  },
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: greencolor,
                    hintText: 'رمز ازر خود را سرچ کنید',
                    hintStyle:
                        TextStyle(fontFamily: 'morabaee', color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        width: 0.0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: showtextresult,
              child: Text(
                '...درحال آماده سازی رمزارزها',
                style: TextStyle(
                  fontFamily: 'morabaee',
                  color: greencolor,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: blackcolor,
                backgroundColor: greencolor,
                child: ListView.builder(
                    itemCount: cryptoc!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return getlisttile(index);
                    }),
                onRefresh: () async {
                  List<crypto> refresh = await getdata();
                  setState(() {
                    cryptoc = refresh;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget gettrending(double trend) {
    return trend <= 0
        ? Icon(
            Icons.trending_down,
            color: redcolor,
          )
        : Icon(
            Icons.trending_up,
            color: greencolor,
          );
  }

  Color getpricechange(double pricechange) {
    return pricechange <= 0 ? redcolor : greencolor;
  }

  Widget getlisttile(int index) {
    return ListTile(
      title: Text(
        cryptoc![index].name,
        style: TextStyle(
          fontSize: 20.0,
          color: greencolor,
        ),
      ),
      subtitle: Text(
        cryptoc![index].symbol,
        style: TextStyle(
          color: greycolor,
        ),
      ),
      leading: SizedBox(
        width: 30,
        child: Center(
          child: Text(
            cryptoc![index].rank.toString(),
            style: TextStyle(
              color: greycolor,
            ),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  cryptoc![index].priceUsd.toStringAsFixed(2),
                  style: TextStyle(color: greycolor, fontSize: 18),
                ),
                Text(
                  cryptoc![index].changePercent24Hr.toStringAsFixed(2),
                  style: TextStyle(
                    color: getpricechange(cryptoc![index].changePercent24Hr),
                  ),
                ),
              ],
            ),
            gettrending(cryptoc![index].changePercent24Hr),
          ],
        ),
      ),
    );
  }

  Future<List<crypto>> getdata() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<crypto> cryptolist = response.data['data']
        .map<crypto>((fromobject) => crypto.frommap(fromobject))
        .toList();
    return cryptolist;
  }

  Future<void> getresultsearch(String keyword) async {
    List<crypto> searchlist = [];

    if (keyword.isEmpty) {
      setState(() {
        showtextresult = true;
      });
      var result = await getdata();
      setState(() {
        cryptoc = result;
        showtextresult = false;
      });
      return;
    }
    searchlist = cryptoc!.where((element) {
      return element.name.toLowerCase().contains(keyword);
    }).toList();
    setState(() {
      cryptoc = searchlist;
    });
  }
}
