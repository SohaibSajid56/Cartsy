import 'product_model.dart';

class Cart {
  static final List<ProductModel> items = [];

  static void add(ProductModel product) {
    items.add(product);
  }

  static void remove(ProductModel product) {
    items.remove(product);
  }

  static void clear() {
    items.clear();
  }

  static double getTotalPrice() {
    return items.fold(0, (sum, item) => sum + item.price);
  }
}
