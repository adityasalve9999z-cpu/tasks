import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatelessWidget {
  ProductListScreen({super.key});
  final List<Product> _products = [
    Product(
      id: 'p1',
      name: 'Wireless Headphones',
      price: 199.99,
      imageUrl:
          'https://via.placeholder.com/150/0000FF/808080?Text=Headphones',
    ),
    Product(
      id: 'p2',
      name: 'Smart Watch',
      price: 299.99,
      imageUrl:
          'https://via.placeholder.com/150/FF0000/FFFFFF?Text=Smart+Watch',
    ),
    Product(
      id: 'p3',
      name: 'Laptop',
      price: 999.99,
      imageUrl:
          'https://via.placeholder.com/150/FFFF00/000000?Text=Laptop',
    ),
    Product(
      id: 'p4',
      name: 'Smartphone',
      price: 699.99,
      imageUrl:
          'https://via.placeholder.com/150/000000/FFFFFF?Text=Smartphone',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const CartScreen(),
                        ),
                      );
                    },
                  ),

                  if (cart.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          cart.itemCount.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: _products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, index) {
          return ProductItem(
            product: _products[index],
          );
        },
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(
      context,
      listen: false,
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 50,
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 5),

                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      cart.addItem(product);

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(
                              'Added ${product.name} to cart!',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                    },
                    child: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}