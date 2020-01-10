class AgendaDestroyMailer < ApplicationMailer
    default from: 'from@example.com'

    def agenda_destroy_mail(email)
      # @team = team
      # @team.users.each do |user|
      #   # binding.irb
      @email = email
        mail to: @email,
             subject: "アジェンダが削除されました。"
    end
  end
