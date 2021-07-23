import 'package:flutter/material.dart';

PreferredSizeWidget myAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
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
                if (states.contains(MaterialState.hovered)) return Colors.black;
                return Colors.white;
              })),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
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
                if (states.contains(MaterialState.hovered)) return Colors.black;
                return Colors.white;
              })),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
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
                if (states.contains(MaterialState.hovered)) return Colors.black;
                return Colors.white;
              })),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
          child: Text('CONTACT US'),
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
                if (states.contains(MaterialState.hovered)) return Colors.black;
                return Colors.white;
              })),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
          child: Text('DOCUMENTATION'),
          onPressed: () {},
        ),
      ],
    ),
  );
}

class CustomAppBar extends StatefulWidget {
  @override
  CustomAppBarState createState() => CustomAppBarState();
}

class CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
                backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
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
                backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
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
                backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
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
                          borderSide: BorderSide(color: Colors.teal.shade900)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal.shade800)),
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
    );
  }
}

Widget textController(
    {TextEditingController controller,
    String hintText,
    String Function(String) validator}) {
  return IntrinsicWidth(
    child: Container(
      width: 300,
      child: TextFormField(
        validator: validator,
        controller: controller,
        decoration:
            InputDecoration(border: OutlineInputBorder(), hintText: hintText),
      ),
    ),
  );
}

Widget dropDownButton(
    {List<String> items, String value, void Function(String) onChanged}) {
  return DropdownButtonFormField(
    decoration: InputDecoration(border: OutlineInputBorder()),
    items: items
        .map((e) => DropdownMenuItem(
              child: Text(e.toString()),
              value: e,
            ))
        .toList(),
    value: value,
    onChanged: onChanged,
  );
}

Widget processButton({void Function() onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text('PROCESS'),
    ),
    style: ButtonStyle(backgroundColor:
        MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered)) {
        return Colors.white;
      }
      return Colors.teal;
    }), textStyle:
        MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered)) {
        return TextStyle(
            letterSpacing: 2.0,
            fontFamily: 'Akaya',
            fontSize: 22,
            fontWeight: FontWeight.bold);
      }
      return TextStyle(fontFamily: 'Akaya', letterSpacing: 2.0);
    }), foregroundColor:
        MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered)) {
        return Colors.teal;
      }
      return Colors.white;
    }), elevation:
        MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered)) {
        return 12.0;
      }
      return 6.0;
    })),
  );
}
