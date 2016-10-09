module Teams
  module LeavingService
    include BaseService

    def call(user, team)
      team.transaction do
        team.remove_player!(user)
        notify_captains(user, team)
      end
    end

    private

    def notify_captains(user, team)
      User.get_revokeable(:edit, team).each do |captain|
        captain.notify!("'#{user.name}' has left the team '#{team.name}'", user_path(user))
      end
    end
  end
end