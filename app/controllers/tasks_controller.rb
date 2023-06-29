class TasksController < ApplicationController
  def index
    @tasks = Task.order(created_at: :desc)
    if params[:task].present?
      @tasks = @tasks.title_like(params[:task][:title]) if params[:task][:title].present?
      @tasks = @tasks.status_is(params[:task][:status]) if params[:task][:status].present?
    end
  
  
    if params[:sort_expired] 
      @tasks = @tasks.order(deadline: :asc)
    end

    if params[:sort_priority] 
      @tasks = Task.order(priority: :desc)
    end
    
    @tasks = @tasks.page(params[:page]).per(10)
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
    params.require(:task).permit(:title, :content, :deadline, :status, :priority)                    
  end
end