import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) {
                      final productId = cart.items.keys.toList()[i];
                      final cartItem = cart.items.values.toList()[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(cartItem.product.imageUrl),
                              backgroundColor: Colors.transparent,
                            ),
                            title: Text(cartItem.product.name),
                            subtitle: Text('Total: \$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    cart.decreaseQuantity(productId);
                                  },
                                ),
                                Text(
                                  '${cartItem.quantity}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    cart.increaseQuantity(productId);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontSize: 20),
                        ),
                        const Spacer(),
                        Chip(
                          label: Text(
                            '\$${cart.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context).primaryTextTheme.titleLarge?.color ?? Colors.white,
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
