class OwnerChangeMailer < ApplicationMailer
  default from: 'from@example.com'

  def owner_change_mail(email)
    @email = email
      mail to: @email,
           subject: "リーダー権限を付与されました。"
  end
end
