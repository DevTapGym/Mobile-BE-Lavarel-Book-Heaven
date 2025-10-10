import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaven_book_app/bloc/auth/auth_bloc.dart';
import 'package:heaven_book_app/bloc/auth/auth_event.dart';
import 'package:heaven_book_app/bloc/auth/auth_state.dart';
import 'package:heaven_book_app/bloc/book/book_bloc.dart';
import 'package:heaven_book_app/bloc/book/book_event.dart';
import 'package:heaven_book_app/bloc/cart/cart_bloc.dart';
import 'package:heaven_book_app/bloc/cart/cart_event.dart';
import 'package:heaven_book_app/bloc/cart/cart_state.dart';
import 'package:heaven_book_app/repositories/book_repository.dart';
import 'package:heaven_book_app/repositories/cart_repository.dart';
import 'package:heaven_book_app/screens/Auth/active_screen.dart';
import 'package:heaven_book_app/screens/Auth/forgot_screen.dart';
import 'package:heaven_book_app/screens/Auth/login_screen.dart';
import 'package:heaven_book_app/screens/Auth/register_screen.dart';
import 'package:heaven_book_app/screens/Auth/reset_screen.dart';
import 'package:heaven_book_app/screens/Cart/check_out_screen.dart';
import 'package:heaven_book_app/screens/Home/detail_review_screen.dart';
import 'package:heaven_book_app/screens/Home/detail_screen.dart';
import 'package:heaven_book_app/screens/Home/home_screen.dart';
import 'package:heaven_book_app/screens/Home/result_screen.dart';
import 'package:heaven_book_app/screens/Orders/detail_order_screen.dart';
import 'package:heaven_book_app/screens/Orders/orders_screen.dart';
import 'package:heaven_book_app/screens/Cart/cart_screen.dart';
import 'package:heaven_book_app/screens/Profile/add_address_screen.dart';
import 'package:heaven_book_app/screens/Profile/change_password_screen.dart';
import 'package:heaven_book_app/screens/Profile/detail_voucher_screen.dart';
import 'package:heaven_book_app/screens/Profile/edit_profile_screen.dart';
import 'package:heaven_book_app/screens/Profile/profile_screen.dart';
import 'package:heaven_book_app/screens/Profile/reward_screen.dart';
import 'package:heaven_book_app/screens/Profile/shipping_address_screen.dart';
import 'package:heaven_book_app/services/auth_service.dart';
import 'package:heaven_book_app/themes/app_colors.dart';
import 'screens/Auth/onboarding_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final bookRepository = BookRepository(AuthService());
  final cartRepository = CartRepository(AuthService());
  final authService = AuthService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BookBloc>(
          create: (_) => BookBloc(bookRepository)..add(LoadBooks()),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authService)..add(AppStarted()),
        ),
        BlocProvider<CartBloc>(
          create:
              (_) => CartBloc(cartRepository, bookRepository)..add(LoadCart()),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedOut) {
            // Chuyển về màn hình login
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/login', (route) => false);
          }
        },
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Heaven App',
      home: const OnboardingWrapper(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/main': (context) => const MainScreen(),
        '/onboarding': (context) => const OnboardingWrapper(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot': (context) => const ForgotScreen(),
        '/active': (context) => const ActiveScreen(),

        //'/reset': (context) => const ResetScreen(),
        '/home': (context) => const HomeScreen(),
        '/result': (context) => const ResultScreen(),
        '/detail': (context) => const DetailScreen(),
        '/detail-review': (context) => DetailReviewScreen(),

        '/order': (context) => const OrdersScreen(),
        '/detail-order': (context) => DetailOrderScreen(),

        '/cart': (context) => const CartScreen(),
        '/check-out': (context) => const CheckOutScreen(),

        '/profile': (context) => const ProfileScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/shipping-address': (context) => const ShippingAddressScreen(),
        '/add-address': (context) => const AddAddressScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
        '/reward': (context) => RewardScreen(),
        '/detail-voucher': (context) => const DetailVoucherScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/reset':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => ResetScreen(email: args['email']),
            );
          default:
            return MaterialPageRoute(builder: (_) => LoginScreen());
        }
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const OrdersScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int badgeCount = 0;

        if (state is CartLoaded) {
          badgeCount = state.cart.totalItems;
        }
        return Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, -2),
                ),
              ],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedItemColor: AppColors.primaryDark,
                unselectedItemColor: Colors.grey,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedFontSize: 14,
                unselectedFontSize: 0,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                  fontSize: 14,
                ),
                showUnselectedLabels: false,
                items: [
                  _buildNavItem(
                    Icons.home_outlined,
                    Icons.home,
                    'Home',
                    _selectedIndex == 0,
                  ),
                  _buildNavItem(
                    Icons.receipt_long_outlined,
                    Icons.receipt_long,
                    'Orders',
                    _selectedIndex == 1,
                  ),
                  _buildNavItem(
                    Icons.shopping_cart_outlined,
                    Icons.shopping_cart,
                    'Cart',
                    _selectedIndex == 2,
                    badgeCount: badgeCount,
                  ),
                  _buildNavItem(
                    Icons.person_outline,
                    Icons.person,
                    'Profile',
                    _selectedIndex == 3,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    IconData activeIcon,
    String label,
    bool isSelected, {
    int badgeCount = 0,
  }) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(
              bottom: 4,
            ), // Tăng khoảng cách giữa icon và text
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.primary : Colors.transparent,
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              size: 28,
              color:
                  isSelected
                      ? AppColors.text
                      : Colors.grey.withValues(alpha: 0.6),
            ),
          ),
          // Badge for cart
          if (badgeCount > 0 && label == 'Cart')
            Positioned(
              right: 6,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      activeIcon: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(activeIcon, size: 28, color: Colors.white),
          ),
          // Badge for active cart
          if (badgeCount > 0 && label == 'Cart')
            Positioned(
              right: 6,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      label: label,
    );
  }
}
