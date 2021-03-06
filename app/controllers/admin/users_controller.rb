class Admin::UsersController < AdminController
  before_filter :admin_only, :except => :index
  def index
    @users = User.all
  end
  def new
    return create if request.post?
    @user = User.new
    render :action => "form"
  end
  
  def edit
    @user = User.find(params[:id])
    render :action => "form"
  end
  
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to admin_users_path
    else
      render :action => "form"
    end

  end 
  
  def create
    # logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      #self.current_user = @usr # !! now logged in
      redirect_to admin_users_path
     # flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      #flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'form'
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
