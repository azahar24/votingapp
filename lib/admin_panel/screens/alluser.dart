import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:votingapp/business_logics/alluserfetch_con.dart';

class UserListScreen extends StatelessWidget {
  final AllUserFetchController userController = AllUserFetchController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: userController.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found.'));
          }
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                child: ListTile(
                  title: Text(user['name'].toString() ?? 'No Name'),
                 //subtitle: Text(user['email'].toString() ?? user['email'].toString()),
                 subtitle: Text(user['phone'] ?? user['email'] ?? 'No Contact Info'),
                  trailing: Text(user['voterid'].toString() ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
