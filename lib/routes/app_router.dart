import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lymar_sample_project/views/home/home_view.dart';
import 'package:lymar_sample_project/views/products/products_view.dart';
import 'package:lymar_sample_project/views/products/product_detail_view.dart';
import 'package:lymar_sample_project/views/cart/cart_view.dart';
import 'package:lymar_sample_project/views/factory_tour/factory_tour_view.dart';
import 'package:lymar_sample_project/views/contact/contact_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: '/products',
        name: 'products',
        builder: (context, state) => const ProductsView(),
      ),
      GoRoute(
        path: '/product/:id',
        name: 'product-detail',
        builder: (context, state) => ProductDetailView(
          productId: state.pathParameters['id'] ?? '1',
        ),
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartView(),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const _PlaceholderView(title: 'About Yelmar'),
      ),
      GoRoute(
        path: '/contact',
        name: 'contact',
        builder: (context, state) => const ContactView(),
      ),
      GoRoute(
        path: '/industries',
        name: 'industries',
        builder: (context, state) => const _PlaceholderView(title: 'Industries'),
      ),
      GoRoute(
        path: '/factory-tour',
        name: 'factory-tour',
        builder: (context, state) => const FactoryTourView(),
      ),
    ],
  );
}

class _PlaceholderView extends StatelessWidget {
  final String title;
  const _PlaceholderView({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020B18),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(color: Color(0xFFF7F5F2), fontSize: 32),
        ),
      ),
    );
  }
}
