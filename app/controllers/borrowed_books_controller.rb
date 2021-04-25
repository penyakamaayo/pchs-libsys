class BorrowedBooksController < ApplicationController
  before_action :check_user

  def check_user
    @user = current_user
    if @user.admin?
    else
      flash[:notice] = "You have no power!" 
      redirect_to root_path
    end
  end

  def index
    @user = current_user
    @borrowed_books = BorrowedBook.all.order('created_at DESC')

    if params[:keyword].present?
      searched_date = Date.parse(params[:keyword])
      # @borrowed_books = @borrowed_books.where('lower(created_at) LIKE :query', query: "%#{(params[:keyword]).downcase}%")
      @borrowed_books = @borrowed_books.where(created_at: searched_date.beginning_of_day..searched_date.end_of_day)
    end
  end

  def new
    @user = current_user
    @borrowed_book = BorrowedBook.new
    @available_books = Book.not_borrowed
    @students = Student.all
  end

  def return_book
    @borrowed_book = BorrowedBook.find(params[:id])
    
    if @borrowed_book.update(return_date: DateTime.now)
      @borrowed_book.book.update(is_available: true)
      flash[:notice] = 'Book is returned sucessfully!'
      redirect_to borrowed_book_path(@borrowed_book.id)
    else
      flash[:error] = 'There seems to be an error in returning book.'
      redirect_to borrowed_book_path(@borrowed_book.id)
    end
  end

  def show
    @user = current_user
    @borrowed_book = BorrowedBook.find(params[:id])
    @due = @borrowed_book.created_at + (@borrowed_book.book.borrow_duration).day
  end

  def create
    @borrowed_book = BorrowedBook.new(borrowed_book_params,)
    @borrowed_book.book.update(is_available: false)

    # student = @borrowed_book.student_id
    if @borrowed_book.student.borrowed_books.not_returned.count > 1
      redirect_to borrowed_books_path, notice: "Borrow failed. Student: #{@borrowed_book.student.fullname_norm} has too many borrowed books."
    else
      if @borrowed_book.save
        flash[:notice] = "Record added successfully!"
        redirect_to action: :new
      else
        flash[:error] = "Record not saved!"
        redirect_to :new
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_borrowed_book
    @borrowed_book = BorrowedBook.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def borrowed_book_params
    params.require(:borrowed_book).permit(:student_id, :book_id, :user_id, :due_date)
  end
end
