class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :delete]

  def index
    @user = current_user
    @subjects = Subject.all
    if params[:keyword].present?
			@subjects = @subjects.search_keyword(params[:keyword])
		end
  end

  def show
    @user = current_user
    @subject
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)
    
    if @subject.save
      flash[:notice] = "Subject category created!"
      redirect_to action: :index
    else
      flash[:error] = "Subject category creation failed ):"
      redirect_to action: :new
    end
  end

  def edit
    @user = current_user

    @subject = Subject.find(params[:id])
  end

  def update
    @subject = Subject.find(params[:id])

    if @subject.update(subject_params)
      flash[:notice] = "Successfully edited!"
      redirect_to action: :index
    else
      flash[:error] = "Edit failed ):"
      redirect_to action: :edit
    end
  end

  def delete
    @subject
    flash[:notice] = 'Subject deleted successfully'
    redirect_to action: :index
  end

  private
  def set_subject
    @subject = Subject.find(params[:id])
  end

  def subject_params
    params.require(:subject).permit(:name)
  end
end
