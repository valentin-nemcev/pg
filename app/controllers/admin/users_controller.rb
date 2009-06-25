class Admin::UsersController < AdminController
  before_filter :admin_only, :except => :index
  def index
    @users = User.all
  end
  def new
    @usr = User.new
    render :action => "edit"
  end
  
  def edit
    @usr = User.find(params[:id])
  end
  
  def update
    @usr = User.find(params[:id])

    if @usr.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to admin_users_path
    else
      render :action => "edit"
    end

  end 
  
  def increment_bug_counter
    User.find(params[:id]).increment!(:bug_counter)
    redirect_to admin_users_path
  end
 
  def create
    logout_keeping_session!
    @usr = User.new(params[:user])
    success = @usr && @usr.save
    if success && @usr.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      #self.current_user = @usr # !! now logged in
      redirect_to admin_users_path
     # flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      #flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'edit'
    end
  end
  
  def destroy
     @user = User.find(params[:id])
     @user.destroy
     redirect_to admin_users_path
   end
   
   protected 
   
   def admin_only
     if not current_user.is_admin?
       flash[:notice] = "Admin only"
       redirect_to admin_users_path
     end
   end
end
