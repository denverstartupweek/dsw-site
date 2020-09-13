class JobFairRole < ApplicationRecord
  belongs_to :job_fair_signup

  validates :title,
    :description,
    :url, presence: true
end
