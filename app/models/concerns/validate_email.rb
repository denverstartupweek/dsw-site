module ValidateEmail
  extend ActiveSupport::Concern

  YOUTUBE_REGEX = %r{\A(?:http://|https://)?youtu.be/(\S+)\z}

  included do
    validate :email_is_valid
  end

  def email_is_valid
    result = EmailInquire.validate(email)
    if result.hint?
      errors.add(:email, "Did you mean #{result.replacement}?")
    elsif result.invalid?
      errors.add(:email, "is not valid")
    end
  end
end