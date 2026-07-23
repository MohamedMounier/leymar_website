import 'package:go_router/go_router.dart';
import 'package:lymar_sample_project/views/home/home_view.dart';
import 'package:lymar_sample_project/views/products/products_view.dart';
import 'package:lymar_sample_project/views/products/product_detail_view.dart';
import 'package:lymar_sample_project/views/contact/contact_view.dart';
import 'package:lymar_sample_project/views/about/about_view.dart';

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
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutView(),
      ),
      GoRoute(
        path: '/contact',
        name: 'contact',
        builder: (context, state) => const ContactView(),
      ),
      // GoRoute(
      //   path: '/industries',
      //   name: 'industries',
      //   builder: (context, state) => const _PlaceholderView(title: 'Industries'),
      // ),
      // GoRoute(
      //   path: '/factory-tour',
      //   name: 'factory-tour',
      //   builder: (context, state) => const FactoryTourView(),
      // ),
    ],
  );
}
