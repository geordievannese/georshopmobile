import 'package:flutter/material.dart';
import 'package:georshop/screens/productentry_form.dart';
import 'package:georshop/screens/list_productentry.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:georshop/screens/login.dart';

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    // Determine the background color based on the button name
    Color getBackgroundColor(String name) {
      if (name == "View Product") {
        return Colors.blue;
      } else if (name == "Add Product") {
        return Colors.red;
      } else if (name == "Logout") {
        return Colors.orange;
      } else {
        return Theme.of(context).colorScheme.secondary;
      }
    }

    return Material(
      color: getBackgroundColor(item.name),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("You have pressed the ${item.name} button!")),
            );

          if (item.name == "Add Product") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductEntryFormPage(),
              ),
            );
          } else if (item.name == "View Product") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductListPage(),
              ),
            );
          } else if (item.name == "Logout") {
            final response = await request.logout(
              "http://127.0.0.1:8000/auth/logout/",
            );
            String message = response["message"];

            if (context.mounted) {
              if (response['status']) {
                String uname = response["username"];
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$message Goodbye, $uname."),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
              }
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}