class StoresController < ApplicationController
  
  before_filter :fetch_recent_items
  before_filter :fetch_popular_items
  
  #editing profile
  def store_edit_profile
#    @profile_user= User.find(:id => current_user.id)
    @profile_userpforile=UserProfile.find_by_user_id(current_user.id)
    @profile_store = Store.find_by_user_id(current_user.id)
#    @profile_image=Image.find_by_sql("select * from images where attachable_type='logo' and attachable_id=#{g.user_id}")    
    
  end

  # Update frofile
  def store_update_profile
     @store = Store.find_by_user_id(current_user.id)
     @user_profile = UserProfile.find_by_user_id(current_user.id)
     @image = Image.find_by_sql("select * from images where attachable_type='logo' and attachable_id=#{current_user.id}")
     unless @image.blank?
       @image.each do |img|
         @gg=params[:image]
         img.update_attributes(params[:image])
       end
     else
       @image=Image.new
       @image=Image.new(params[:image])
       @image.attachable_type='logo'
       @image.attachable_id=current_user.id
       @image.save
     end
    if @store.update_attributes(params[:store]) && @user_profile.update_attributes(params[:user_profile])
       redirect_to store_show_path(current_user.id)
    end
     

  end
  
  def store_index
    @stores=Store.all
    @featured_items=Item.where(:available == true).order('RAND()').limit(8)
    @featured_stores=Store.where(:available == true).order('RAND()').limit(2)
#    @item_image = Image.find_by_sql("select * from images where ")
    puts "=================================================================================================="
    puts YAML::dump(@featured_items)
    #     @stores.each do |f|
    #      puts "User_id>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#{f.user_id}"
    #     end
  end

  def store_new
    @store = Store.new
    @user=User.new
    @address = Address.new
    @user_profile=UserProfile.new
  end

  def store_create
    @store=Store.new(params[:store])
    @user=User.new(params[:user])
    @address = Address.new(params[:address])
    @user_profile=UserProfile.new(params[:user_profile])
    #    puts "22222222222222222222222222#{YAML::dump(@address)}"
    session[:address] = @address
    #    puts "DDDDDDDDDDDSSSSSSSSSSSSSS#{YAML::dump(session[:address])}"
    session[:user]=@user
    session[:store]=@store
    session[:user_profile]=@user_profile
    redirect_to store_edit_path
  end

  def store_edit

  end

  def store_update
    
    @store=session[:store]
    @user=session[:user]
    @address = session[:address]
    @user_profile=session[:user_profile]
    @store1=Store.new(params[:store])
    @user1=User.new(params[:user])
    @address1= params[:address]
    @user_profile1=UserProfile.new(params[:user_profile])
    #    puts "User Profileeeeeeeeeeeeeeeeeeeeeeeeeeee #{@user_profile1.business_address}"
    @store.established_in=@store1.established_in
    @store.gear_designed_by=@store1.gear_designed_by
    @store.cause=@store1.cause

    unless @user_profile1.location.blank?
      #      puts "SSSSSSSSDETFGFGFF#{@user_profile1.location}"
      #      puts "AAAAAAAAAAAAAAAAAAAAAAAAAA"
      @address.business_address = true
      
    else
      @address.business_address = false
    end
    @user_profile.location=@user_profile1.location
    @user_profile.website=@user_profile1.website
    @user_profile.sports=@user_profile1.sports
    @user.first_name=@address.first_name
    @user.last_name=@address.last_name
    #    puts "User Profileeeeeeeeeeeeeeeeeeeeeeeeeeee #{YAML::dump(@address)}"
    if @address.save
      @store.address_id=@address.id
      @user.shipping_address_id=@address.id
      #       puts "===================================================== #{YAML::dump(@user)}"
      if @user.save
      
        @store.user_id=@user.id
        @user_profile.user_id=@user.id
        @user_profile.save
        @store.save
        redirect_to login_path
      else
        render :action => "store_new"
      end
    else
      render :action => "store_edit"
    end
  end

  def store_show
    @store=Store.find(params[:id])
#    @logo = Image.find_by_sql("select * from images where attachable_type='logo' and attachable_id=#{params[:id]}")
    @featured_items=Item.where(:available == true).order('RAND()').limit(8)
    #   if @store.user_id == Item.user_id
    #     @item=Item.all
    #   end
  end

end
