class TasksController < ApplicationController
  # controller for actions related to tasks

  before_action :set_task, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    # @tasks automatically set by Cancan gem.
    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @tasks }
    end
  end

  def new
    @task=Task.new
    @task.due_date = Date.today + 2.days
  end

  def edit
    # TODO
  end

  def update
    complete_update(step: :update) do
      @task && @task.update_attributes(params[:task])
    end
  end
  
  def create
    @task = Task.new params[:task]

    # Attributes that are not set directly from the params hash should go here
    @task.owner=User.find_by_id current_user.id if current_user
    
    complete_update(step: :create) do
      @task.save
    end
  end

  private
  def complete_update(options_in)
    options={success_http_status: options_in[:step] == :update ? :ok : :created,
             error_http_status: :unprocessable_entity,
             success_message: options_in[:step] == :update ? t(:successful_resource_update) :
               t(:successful_resource_creation)}
    
    @task.category_ids.delete_if { |k| k.nil? or k == ""}

    # If the task exists (in case this is an update), and it can be updated... 
    respond_to do |format|
      # The block should return Boolean
      db_transaction_success = yield

      if db_transaction_success
        format.html { redirect_to @task, notice: "#{options[:success_message]}: task" }
        format.json { render json: @task, status: options[:success_http_status] }
      else
        flash[:alert]=:errors_found 
        format.html { render action: options[:step] == :new ? 'new' : 'edit' }
        # Let's return a 422 - we'll have to initialize an empty task if the params hash wasn't able to find one
        @task ||= Task.new
        format.json { render json: @task.errors, status: options[:error_http_status] }
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    begin
      @task = Task.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      respond_to do |format|
        format.html { redirect_to tasks_path }
        format.json { render json: {}, status: :unprocessable_entity }
      end
    else
      return true
    end
  end
  
  # Strong params: this will be passed the params[resource] hash by default by before_action
  def task_strong_params(p)
    if p.nil?
      nil
    else
      p.permit(:title, :due_date, category_ids: []) 
    end
  end
end
