class TeamsController < ApplicationController
  before_action :authenticate_user!
<<<<<<< HEAD
  before_action :set_team, only: %i[show edit update destroy owner_change]
=======
  before_action :set_team, only: %i[show edit update destroy]
>>>>>>> 2b41c5da901f7c635c1e2a9bccfd2a6e8314e072
  before_action :ensure_correct_user, only:[:edit, :update]

  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  def edit
    if @team.owner.id != current_user.id
    redirect_to team_url, notice: 'チーム情報を編集する権限がありません。'
    end
  end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: I18n.t('views.messages.create_team')
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
      render :new
    end
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: I18n.t('views.messages.update_team')
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: I18n.t('views.messages.delete_team')
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end

  def owner_change
    @user = User.find_by(id: params[:owner_change_user_id])
    if @team.update(owner: @user)
      OwnerChangeMailer.owner_change_mail(@user.email).deliver
      redirect_to team_url, notice: 'リーダー権限を移動しました。'
    else
      redirect_to team_url, notice: 'リーダー権限は移動できません。'
    end
  end

  private

  def ensure_correct_user
    if @team.owner != current_user
      flash[:notice] = "権限がありません"
    end
  end

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache keep_team_id]
  end
end
