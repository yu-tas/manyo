class TasksController < ApplicationController
  def index
    @tasks = Task.all
  
    if params[:task].present?
      if params[:task][:title].present? && params[:task][:status].present?
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%").where(status: params[:task][:status])
      elsif params[:task][:title].present?
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%")
      elsif params[:task][:status].present?
        @tasks = @tasks.where(status: params[:task][:status])
      end
    end
  
  
    if params[:sort_expired] 
      @tasks = @tasks.order(deadline: :asc)
    end
  end
  def show
    @task = Task.find(params[:id])
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
      redirect_to tasks_path, notice:"タスクを削除しました！"
  end

  def edit
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if params[:back]
      render :new
    else
      if @task.save
        redirect_to tasks_path, notice: "タスクを作成しました！"
      else
        render :new  
      end
    end          
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: "タスクを編集しました！"
    else 
      render :edit
    end
  end

  def confirm
    @task = Task.new(task_params)
    render :new if @task.invalid?
  end

  
  
  private                                                      
  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status)                    
  end
end