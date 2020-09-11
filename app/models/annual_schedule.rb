# frozen_string_literal: true

class AnnualSchedule < ApplicationRecord
  CFP_CYCLE = "cfp"
  VOTING_CYCLE = "voting"
  REGISTRATION_CYCLE = "registration"
  WEEK_CYCLE = "week"
  POST_WEEK_CYCLE = "post_week"
  PITCH_APPLICATION_CYCLE = "pitch_application"
  PITCH_VOTING_CYCLE = "pitch_voting"
  AMBASSADOR_APPLICATION_CYCLE = "ambassador_application"
  SPONSORSHIP_CYCLE = "sponsorship"

  CYCLES = [CFP_CYCLE,
    VOTING_CYCLE,
    REGISTRATION_CYCLE,
    WEEK_CYCLE,
    POST_WEEK_CYCLE,
    PITCH_APPLICATION_CYCLE,
    PITCH_VOTING_CYCLE,
    AMBASSADOR_APPLICATION_CYCLE,
    SPONSORSHIP_CYCLE].freeze

  validates :week_start_at,
    :week_end_at,
    presence: true

  validates :year,
    presence: true,
    uniqueness: true

  jsonb_accessor :dates,
    cfp_open_at: :date,
    cfp_close_at: :date,
    voting_open_at: :date,
    voting_close_at: :date,
    registration_open_at: :date,
    week_start_at: :date,
    week_end_at: :date,
    sponsorship_open_at: :date,
    sponsorship_close_at: :date,
    pitch_application_open_at: :date,
    pitch_application_close_at: :date,
    pitch_voting_open_at: :date,
    pitch_voting_close_at: :date,
    ambassador_application_open_at: :date,
    ambassador_application_close_at: :date

  class << self
    def current
      where(year: Date.today.year).first
    end

    def next
      where(year: Date.today.year + 1).first
    end

    delegate :cfp_open?, to: :current
    delegate :voting_open?, to: :current
    delegate :registration_open?, to: :current
    delegate :pitch_application_open?, to: :current
    delegate :pitch_voting_open?, to: :current
    delegate :sponsorship_open?, to: :current
    delegate :ambassador_application_open?, to: :current
    delegate :in_week?, to: :current
    delegate :post_week?, to: :current
    delegate :active_cycles, to: :current

    def current_day_index
      zone = ActiveSupport::TimeZone["America/Denver"]
      day_index = (
        (zone.now.at_beginning_of_day - current.week_start_at.at_beginning_of_day.in_time_zone(zone)
        ) / 1.day).ceil + 1
    end
  end

  def cfp_open?
    return false if cfp_open_at.blank? || cfp_close_at.blank?
    Time.zone.now > date_in_time_zone(cfp_open_at).at_beginning_of_day &&
      Time.zone.now < date_in_time_zone(cfp_close_at).at_end_of_day
  end

  def voting_open?
    return false if voting_open_at.blank? || voting_close_at.blank?
    Time.zone.now > date_in_time_zone(voting_open_at).at_beginning_of_day &&
      Time.zone.now < date_in_time_zone(voting_close_at).at_end_of_day
  end

  def registration_open?
    return false if registration_open_at.blank?
    Time.zone.now > date_in_time_zone(registration_open_at).at_beginning_of_day &&
      Time.zone.now < date_in_time_zone(week_end_at).at_end_of_day
  end

  def pitch_application_open?
    return false if pitch_application_open_at.blank? || pitch_application_close_at.blank?
    Time.zone.now > date_in_time_zone(pitch_application_open_at).at_beginning_of_day &&
      Time.zone.now < date_in_time_zone(pitch_application_close_at).at_end_of_day
  end

  def pitch_voting_open?
    return false if pitch_voting_open_at.blank? || pitch_voting_close_at.blank?
    Time.zone.now > date_in_time_zone(pitch_voting_open_at).at_beginning_of_day &&
      Time.zone.now < date_in_time_zone(pitch_voting_close_at).at_end_of_day
  end

  def sponsorship_open?
    return false if sponsorship_open_at.blank? || sponsorship_close_at.blank?
    Time.zone.now > date_in_time_zone(sponsorship_open_at).at_beginning_of_day &&
      Time.zone.now < date_in_time_zone(sponsorship_close_at).at_end_of_day
  end

  def ambassador_application_open?
    return false if ambassador_application_open_at.blank? || ambassador_application_close_at.blank?
    Time.zone.now > date_in_time_zone(ambassador_application_open_at).at_beginning_of_day &&
      Time.zone.now < date_in_time_zone(ambassador_application_close_at).at_end_of_day
  end

  def in_week?
    Time.zone.now > date_in_time_zone(week_start_at).at_beginning_of_day &&
      Time.zone.now < date_in_time_zone(week_end_at).at_end_of_day
  end

  def post_week?
    Time.zone.now > date_in_time_zone(week_end_at).at_end_of_day
  end

  def active_cycles
    cycles = []
    cycles << CFP_CYCLE if cfp_open?
    cycles << VOTING_CYCLE if voting_open?
    cycles << REGISTRATION_CYCLE if registration_open?
    cycles << WEEK_CYCLE if in_week?
    cycles << POST_WEEK_CYCLE if post_week?
    cycles << PITCH_APPLICATION_CYCLE if pitch_application_open?
    cycles << PITCH_VOTING_CYCLE if pitch_voting_open?
    cycles << SPONSORSHIP_CYCLE if pitch_application_open?
    cycles << AMBASSADOR_APPLICATION_CYCLE if ambassador_application_open?
    cycles << SPONSORSHIP_CYCLE if sponsorship_open?
    cycles
  end

  private

  def date_in_time_zone(date, zone = "America/Denver")
    date.in_time_zone(ActiveSupport::TimeZone[zone])
  end
end
