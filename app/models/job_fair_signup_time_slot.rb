class JobFairSignupTimeSlot < ApplicationRecord
  belongs_to :job_fair_signup
  belongs_to :submission
end
