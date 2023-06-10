import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'applicants.dart';
import 'details.dart';

class ProjectCard extends StatelessWidget {
  final String name;
  final String desc;
  final String imageUrl;

  const ProjectCard({Key? key,
      required this.name,
      required this.desc,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text('Project'),
              ),
              body: Center(child: Text(name)),
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: Image.network(imageUrl),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 20),
              ),
              // Row(
              //   children: [
              //     for (int i = 0; i < stars; i++)
              //       const Icon(Icons.star, color: Colors.yellow)
              //   ],
              // )
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Text(title),
              Text(desc),
            ],
          ),
        ),
      ),
    );
  }
}
