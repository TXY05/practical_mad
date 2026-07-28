import 'package:p4/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:p4/main.dart';
import 'package:provider/provider.dart';
import 'package:p4/model/item.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [CartListWidget()],
      ),
    );
  }
}

class CartListWidget extends StatefulWidget {
  const CartListWidget({super.key});

  @override
  State<CartListWidget> createState() => _CartListWidgetState();
}

class _CartListWidgetState extends State<CartListWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return cart.itemList.isNotEmpty
            ? ListView.separated(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return CartItem(item: cart.itemList[index]);
                },
                itemCount: cart.itemList.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              )
            : const Center(child: Text('Cart is empty.'));
      },
    );
  }
}

class CartItem extends StatelessWidget {
  final Item item;

  const CartItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$item'),
        const Expanded(child: SizedBox()),
        TextButton(
          onPressed: () {
            Provider.of<CartProvider>(context, listen: false).remove(item);
          },
          child: const Text('Remove'),
        ),
      ],
    );
  }
}
