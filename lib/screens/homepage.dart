import 'package:final_project/tools/curveRanging.dart';
import 'package:final_project/tools/levelling.dart';
import 'package:final_project/tools/traversing.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget drawerItem({@required String title, Image image}) {
    return Container(
      height: 70,
      child: TextButton(
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Row(
            children: [
              Icon(
                Icons.account_balance,
                color: Colors.black,
              ),
              SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        style: ButtonStyle(textStyle:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered))
            return TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold);
          return TextStyle(fontSize: 18, color: Colors.black);
        })),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              child: Text('HOME'),
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Medieval');
                    return TextStyle(fontSize: 18, fontFamily: 'Inika');
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith(
                      ((Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.black;
                    return Colors.white;
                  })),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.teal)),
              onPressed: () {},
            ),
            TextButton(
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Medieval');
                    return TextStyle(fontSize: 18, fontFamily: 'Inika');
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith(
                      ((Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.black;
                    return Colors.white;
                  })),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.teal)),
              child: Text('ABOUT'),
              onPressed: () {},
            ),
            TextButton(
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Medieval');
                    return TextStyle(fontSize: 18, fontFamily: 'Inika');
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith(
                      ((Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.black;
                    return Colors.white;
                  })),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.teal)),
              child: Text('CONTACT US'),
              onPressed: () {},
            ),
            SizedBox(
              width: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: 300,
                height: 150,
                alignment: Alignment.center,
                child: Form(
                  child: TextFormField(
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.teal.shade900)),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.teal.shade800)),
                        hintText: '  Search here',
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {},
                            color: Colors.white,
                            splashRadius: 20.0,
                          ),
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 400,
                child: Carousel(
                    dotSize: 5.0,
                    indicatorBgPadding: 5,
                    dotBgColor: Colors.teal,
                    showIndicator: true,
                    autoplayDuration: Duration(seconds: 4),
                    animationDuration: Duration(milliseconds: 400),
                    animationCurve: Curves.easeInQuint,
                    images: [
                      Image.asset(
                        'images/theo.jpeg',
                      ),
                      Image.asset(
                        'images/survey_with_theo.jpg',
                        fit: BoxFit.fill,
                      ),
                      Image.asset('images/sekina.jpeg'),
                      Image.asset('images/field_work.jpg'),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Text(
                    'Hello There!',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Redressed'),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                  child: Text('You are few clicks away from enjoying...',
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.black87,
                          fontFamily: 'Redressed'))),
              SizedBox(
                height: 15,
                width: 300,
                child: Divider(
                  color: Colors.teal[100],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: itemCard(
                          title: 'Levelling',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Levelling()));
                          })),
                  Expanded(
                      child: itemCard(
                          title: 'Traversing',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Traversing()));
                          })),
                  Expanded(
                      child: itemCard(
                          title: 'Curve Ranging',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CurveRanging()));
                          }))
                ],
              ),
              SizedBox(
                height: 100,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: SelectableText(
                          'CONTACT',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 26,
                              fontFamily: 'Akaya'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                          'Kwame Nkrumah University of Science and Technology',
                          toolbarOptions:
                              ToolbarOptions(copy: true, selectAll: true),
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Caveat',
                              color: Colors.black)),
                      SizedBox(
                        height: 10,
                      ),
                      SelectableText('Department of Geomatic Engineering',
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Caveat',
                              color: Colors.black)),
                      SizedBox(
                        height: 10,
                      ),
                      SelectableText('Kumasi - Ghana',
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Caveat',
                              color: Colors.black)),
                      SizedBox(
                        height: 10,
                      ),
                      SelectableText('geomaticeng@knust.edu.gh',
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Caveat',
                              color: Colors.black))
                    ],
                  ),
                ),
              ),
              // Expanded(
              //   flex: 0,
              //   child: GridView.builder(
              //       itemCount: 3,
              //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //           crossAxisCount: 3),
              //       itemBuilder: (context, index) {
              //         return itemCard(title: 'Levelling');
              //       }),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget itemCard({String title, void Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 250,
        child: ElevatedButton(
          onPressed: () {
            onPressed();
          },
          // style: ButtonStyle(backgroundColor:
          //     MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          //   if (states.contains(MaterialState.hovered)) {
          //     return Colors.teal[100];
          //   }
          //   return Colors.teal[600];
          // })),
          child: Column(
            children: [
              Container(
                  height: 80,
                  child: Center(
                    child: Text(
                      title.toUpperCase(),
                      style: TextStyle(
                          fontSize: 25,
                          color: textColor,
                          fontFamily: 'Berkshire'),
                    ),
                  )),
              SizedBox(
                child: Divider(
                  color: Colors.white,
                ),
                width: 300,
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  Color textColor = Colors.lightGreenAccent[900];
}
