import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeveloperProfilesScreen extends StatelessWidget {
  final List<Map<String, String>> developers = [
    {'name': 'Azahar Uddin'},
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Developer Name'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Container(
            height: 170.717.h,
            width: 172.w,
            decoration: BoxDecoration(
               //borderRadius: BorderRadius.circular(40.r),
              image: DecorationImage(
                image: AssetImage('assets/img/green.png'),
                fit: BoxFit.cover
              ),
            ),
          ),
          SizedBox(height: 20.h,),
          Expanded(
            child: ListView.builder(
              itemCount: developers.length,
              itemBuilder: (context, index) {
                final developer = developers[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      developer['name']!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    // trailing: ElevatedButton(
                    //   onPressed: () {
                    //     // Add action (e.g., navigate to profile)
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(content: Text('Viewing ${developer['name']}')),
                    //     );
                    //   },
                    //   child: Text('View Profile'),
                    // ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}