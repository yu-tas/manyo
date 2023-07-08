class TasksController < ApplicationController
  def index
    @tasks = current_user.tasks.order(created_at: :desc)

    if params[:task].present?
      @tasks = @tasks.title_like(params[:task][:title]) if params[:task][:title].present?
      @tasks = @tasks.status_is(params[:task][:status]) if params[:task][:status].present?
      
      # ラベルが選択されている場合のみ検索を行う
      if params[:task][:label_ids].present? && params[:task][:label_ids].reject(&:empty?).present?
        @tasks = @tasks.label_is(params[:task][:label_ids])
      end
    end       
  
    if params[:sort_expired] 
      @tasks = @tasks.reorder(deadline: :asc)
    end

    if params[:sort_priority] 
      @tasks = @tasks.reorder(priority: :desc)
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
    @task = current_user.tasks.build(task_params)
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
    @task = current_user.tasks.build(task_params)
    render :new if @task.invalid?
  end

  
  
  private                                                      
  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status, :priority, label_ids:[])                    
  end
end