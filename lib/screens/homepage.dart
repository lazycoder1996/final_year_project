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
                          fontSize: 20, fontWeight: FontWeight.bold);
                    return TextStyle(fontSize: 18);
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
                          fontSize: 20, fontWeight: FontWeight.bold);
                    return TextStyle(fontSize: 18);
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
                          fontSize: 20, fontWeight: FontWeight.bold);
                    return TextStyle(fontSize: 18);
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
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                  child: Text('You are few clicks away from enjoying...',
                      style: TextStyle(fontSize: 22, color: Colors.black87))),
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
                  Expanded(child: itemCard(title: 'Levelling')),
                  Expanded(child: itemCard(title: 'Traversing')),
                  Expanded(child: itemCard(title: 'Curve Ranging'))
                ],
              ),
              SizedBox(
                height: 100,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black45,
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
                        child: Text(
                          'CONTACT',
                          style: TextStyle(color: Colors.white70, fontSize: 26),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Kwame Nkrumah University of Science and Technology',
                          style: TextStyle(fontSize: 20)),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Department of Geomatic Engineering',
                          style: TextStyle(fontSize: 20)),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Kumasi - Ghana', style: TextStyle(fontSize: 20)),
                      SizedBox(
                        height: 10,
                      ),
                      Text('someone@gmail.com', style: TextStyle(fontSize: 20))
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
                      title,
                      style: TextStyle(
                          fontSize: 20,
                          color: textColor,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              SizedBox(
                child: Divider(
                  color: textColor,
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

  Color textColor = Colors.teal[100];
}
