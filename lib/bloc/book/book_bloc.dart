import 'package:flutter_bloc/flutter_bloc.dart';
import 'book_event.dart';
import 'book_state.dart';
import '../../repositories/book_repository.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository _repository;

  BookBloc(this._repository) : super(BookInitial()) {
    on<LoadBooks>(_onLoadBooks);
    on<LoadSearchBooks>(_onLoadSearchBooks);
    on<LoadCategoryBooks>(_onLoadCategoryBooks);
    on<LoadAllBooks>(_onLoadAllBooks);
  }

  Future<void> _onLoadBooks(LoadBooks event, Emitter<BookState> emit) async {
    emit(BookLoading());
    try {
      final popularBooks = await _repository.getPopularBooks();
      final saleOffBooks = await _repository.getSaleOffBooks();
      final bestSellingBooks = await _repository.getBestSellingBooksInYear();
      final bannerBooks = await _repository.getBannerBooks();
      emit(
        BookLoaded(
          popularBooks: popularBooks,
          saleOffBooks: saleOffBooks,
          bestSellingBooks: bestSellingBooks,
          bannerBooks: bannerBooks,
        ),
      );
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> _onLoadSearchBooks(
    LoadSearchBooks event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());
    try {
      final searchResults = await _repository.searchBooks(event.query);
      emit(BookSearchLoaded(searchResults));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> _onLoadCategoryBooks(
    LoadCategoryBooks event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());
    try {
      final categoryBooks = await _repository.getBooksByCategory(
        event.categoryId,
      );
      emit(BookCategoryLoaded(categoryBooks));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> _onLoadAllBooks(
    LoadAllBooks event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());
    try {
      final allBooks = await _repository.getAllBooks();
      emit(BookLoadAll(allBooks));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }
}
