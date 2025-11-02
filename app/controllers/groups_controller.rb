class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy, :join, :leave]
  before_action :check_membership, only: [:show]

  def index
    @groups = current_user.groups
    @available_groups = Group.where.not(id: current_user.groups.ids)
  end

  def show
    unless current_user.has_uploaded_gifts?
      flash[:alert] = "You must upload at least one gift to your list before viewing other members' gifts."
      redirect_to gifts_path
      return
    end
    
    @members = @group.users
    @member_gifts = @group.users.where.not(id: current_user.id).flat_map(&:gifts)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    
    if @group.save
      @group.memberships.create(user: current_user)
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully deleted.'
  end

  def join
    if @group.memberships.create(user: current_user)
      redirect_to @group, notice: 'Successfully joined the group.'
    else
      redirect_to groups_path, alert: 'Could not join the group.'
    end
  end

  def leave
    membership = @group.memberships.find_by(user: current_user)
    if membership&.destroy
      redirect_to groups_path, notice: 'Successfully left the group.'
    else
      redirect_to @group, alert: 'Could not leave the group.'
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def check_membership
    unless current_user.groups.include?(@group)
      redirect_to groups_path, alert: 'You must be a member of this group to view it.'
    end
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
