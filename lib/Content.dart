import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Configurations.dart';


class Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}


class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Attendance"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: Configurations.attendance.length,
          itemBuilder: (context, index) {
            String date = Configurations.attendance[index][0].toString();
            bool isPresent = Configurations.attendance[index][1] == 1 ? true : false;
            
            return Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(date, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Configurations.attendance[index][1] = isPresent ? 0 : 1;
                      });
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: isPresent ? Colors.green : Colors.red,
                      child: Text(
                        isPresent ? "P" : "A",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
