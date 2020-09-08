require "google/apis/youtube_v3"

class CreateOrUpdateVideoIntegrationsJob
  include Sidekiq::Worker

  def perform(submission_id)
    submission = Submission.find(submission_id)
    YoutubeLiveSubmissionSyncer.new(submission).run!
    ZoomSubmissionSyncer.new(submission).run!
  end
end