class NotificationsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.new_submission.subject
  #
  def notify_of_new_submission(chair, submission)
    @chair = chair
    @submission = submission
    @track = @submission.track
    mail to: chair.email, subject: "A new DSW submission has been received for the #{@track.name} track"
  end

  def notify_of_submission_update(chair, submission, reminder = false)
    @chair = chair
    @submission = submission
    @track = @submission.track
    subject = "#{reminder ? "REMINDER: " : ""}#{@submission.submitter.name} has proposed an update needing your approval for the #{@track.name} track."
    mail to: chair.email, subject: subject
  end

  def notify_of_update_acceptance(submission)
    @submission = submission
    mail to: notification_emails(@submission),
         subject: "Your proposed session updates have been accepted"
  end

  def notify_of_feedback(feedback, chair)
    @chair = chair
    @feedback = feedback
    mail to: chair.email, subject: "Feedback has been submitted for \"#{@feedback.submission.title}\""
  end

  def confirm_new_submission(submission)
    @submission = submission
    mail to: @submission.contact_emails, subject: "Thanks for submitting a session proposal for Denver Startup Week!"
  end

  def voting_open(submission)
    @submission = submission
    mail to: @submission.contact_emails, subject: "Voting for Denver Startup Week Sessions Is Now Open!"
  end

  def notify_of_new_inquiry(inquiry)
    @inquiry = inquiry
    mail to: ENV["VOLUNTEER_SIGNUP_EMAIL_RECIPIENTS"].split(","),
         subject: "Someone has inquired about DSW",
         reply_to: "#{@inquiry.contact_name} <#{@inquiry.contact_email}>"
  end

  def notify_of_new_job_fair_signup(signup)
    @signup = signup
    mail to: ENV["JOB_FAIR_SIGNUP_EMAIL_RECIPIENTS"].split(","),
         subject: "Someone has signed up to exhibit at the DSW Job Fair",
         reply_to: "#{@signup.user.name} <#{@signup.user.email}>",
         cc: @signup.notification_emails
  end

  def confirm_job_fair_signup(job_fair_signup)
    @signup = job_fair_signup
    mail to: @signup.notification_emails,
         subject: "Your job fair signup for Denver Startup Week #{Date.today.year} has been accepted"
  end

  def notify_of_new_sponsor_signup(sponsor_signup)
    @sponsor_signup = sponsor_signup
    mail to: ENV["SPONSOR_SIGNUP_EMAIL_RECIPIENTS"].split(","), subject: "Someone is interested in sponsoring DSW"
  end

  def notify_of_new_article(article)
    @article = article
    mail to: ENV["NEW_ARTICLE_EMAIL_RECIPIENTS"].split(","), subject: "A new article has been submitted for DSW"
  end

  def notify_of_submission_acceptance(submission)
    @submission = submission
    mail to: notification_emails(@submission),
         subject: "RESPONSE NEEDED: Your Denver Startup Week session has been accepted!",
         from: @submission.track.email_alias,
         reply_to: @submission.track.email_alias,
         cc: @submission.track.email_alias
  end

  def notify_of_submission_rejection(submission)
    @submission = submission
    mail to: notification_emails(@submission),
         subject: "Your session proposal for Denver Startup Week"
  end

  def notify_of_submission_waitlisting(submission)
    @submission = submission
    mail to: notification_emails(@submission),
         subject: "Your session proposal for Denver Startup Week",
         from: @submission.track.email_alias,
         reply_to: @submission.track.email_alias,
         cc: @submission.track.email_alias
  end

  def notify_of_submission_venue_match(submission)
    @submission = submission
    mail to: [
      notification_emails(@submission),
      @submission.venue.contact_emails,
      @submission.submitter.email
    ].flatten.uniq,
         subject: "Denver Startup Week session location intro",
         from: @submission.track.email_alias,
         reply_to: @submission.track.email_alias,
         cc: @submission.track.email_alias
  end

  def confirm_registration(registration)
    @registration = registration
    mail to: @registration.user.email,
         subject: "You are registered for Denver Startup Week #{Date.today.year}"
  end

  def send_attendee_message(message, users)
    @message = message
    sendgrid_recipients users.map(&:email)
    mail to: "Denver Startup Week <info@denverstartupweek.org>",
         subject: "Regarding '#{message.submission.full_title}': #{message.subject}"
  end

  def session_thanks(submission)
    @submission = submission
    mail to: notification_emails(@submission),
         subject: "Thank you, DSW session organizers!"
  end

  private

  def notification_emails(submission)
    [submission.contact_emails, submission.submitter.email].flatten.uniq
  end
end
