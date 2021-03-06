class StudentsController < ApplicationController
  before_action :check_user
  before_action :set_student, only: %i[ show edit update destroy ]

  def check_user
    @user = current_user
    if @user.admin?
    else
      flash[:notice] = "You have no power!" 
      redirect_to root_path
    end
  end

  # GET /students or /students.json
  def index
    @students = Student.all
    @students = @students

    if params[:keyword].present?
			@students = @students.where('lower(lrn) LIKE :query OR lower(firstname) LIKE :query OR lower(lastname) LIKE :query', query: "%#{(params[:keyword]).downcase}%")
		end

    respond_to do |format|
      format.html { }
      format.js {  }
    end
  end

  # GET /students/1 or /students/1.json
  def show
    @user = current_user
    @borrowed_books = Student.find(params[:id]).unreturned_books
    @borrowed_returned = Student.find(params[:id]).returned_books
  end

  # GET /students/new
  def new
    @user = current_user
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
    @user = current_user
    @student = Student.find(params[:id])
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)
    
    if @student.save
      flash[:notice] = "Student added successfully!"
      redirect_to action: :new
    else
      flash[:error] = "Book not saved!"
      render :new
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def import
    Student.import(params[:file])
    redirect_to students_path, notice: "Students added successfully!"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:lrn, :firstname, :lastname, :contact_number)
    end
end
