class SchedulesController < ApplicationController
  respond_to :html
  respond_to :json, only: :index
  respond_to :ics, only: :index

  before_action :ensure_registered!, only: %i[create destroy]
  before_action :authenticate_user!, only: %i[create destroy]

  def index
    @sessions = Submission
      .for_year(params[:year])
      .for_schedule
      .order(:start_day)
      .includes(:venue,
        :submitter,
        :track,
        :cluster,
        sponsorship: :track)
    respond_to do |format|
      format.html do
        redirect_to schedules_by_year_by_day_path({year: current_year_or_default, start_day: current_day_or_default}.merge(request.query_parameters))
      end
      format.json do
        respond_with @sessions
      end
    end
  end

  def by_day
    @day_index = Submission::DAYS.invert[params[:start_day].titleize]
    @sessions = Submission
      .for_year(params[:year])
      .for_schedule
      .for_start_day(params[:start_day])
      .for_schedule_filter(params[:filter], current_user)
      .fulltext_search(params[:terms])
      .order(:start_hour)
      .includes(:venue,
        :submitter,
        :track,
        :cluster,
        sponsorship: :track)
    respond_with @sessions
  end

  def show
    @session = Submission
      .for_schedule
      .where(id: params[:id].to_i)
      .order(:start_day)
      .includes(:venue,
        :track,
        :cluster,
        :presenters,
        sponsorship: :track)
      .first!

    @related_sessions = @session
      .cached_similar_items
      .for_schedule
      .limit(3)
      .includes(:venue,
        :track,
        :cluster,
        sponsorship: :track)
  end

  def feed
    registration = Registration.where(calendar_token: params[:id]).includes(:user).first!
    @sessions = registration
      .submissions.for_current_year
      .for_schedule
      .order("created_at asc")
      .includes(:venue,
        :submitter,
        :track,
        :cluster,
        sponsorship: :track)
    if stale?(@sessions)
      respond_to do |format|
        format.ics do
          render body: to_calendar(registration, @sessions).to_ical, media_type: "text/calendar"
        end
      end
    end
  end

  def create
    @session = Submission
      .for_schedule
      .where(id: params[:id].to_i)
      .first!
    current_registration.submissions << @session unless current_registration.submissions.include?(@session)
    redirect_to schedule_path(@session)
  end

  def destroy
    @session = Submission
      .for_schedule
      .where(id: params[:id].to_i)
      .first!
    current_registration.session_registrations.where(submission_id: @session.id).destroy_all
    redirect_to schedule_path(@session)
  end

  private

  def current_day_or_default
    if AnnualSchedule.in_week?
      Submission::DAYS[AnnualSchedule.current_day_index].downcase
    else
      "monday"
    end
  end

  helper_method :current_day_or_default

  def current_year_or_default
    if params[:year].present?
      params[:year]
    elsif AnnualSchedule.registration_open? || AnnualSchedule.post_week?
      Date.today.year
    else
      Date.today.year - 1
    end
  end

  helper_method :current_year_or_default

  def to_calendar(registration, sessions)
    Icalendar::Calendar.new.tap do |calendar|
      calendar.x_wr_calname = "#{registration.user.name}'s Denver Startup Week #{Date.today.year} Schedule"
      sessions.each do |submission|
        url = schedule_url(submission)
        event_start = submission.start_datetime
        event_end = submission.end_datetime
        tzid = submission.start_datetime.time_zone.tzinfo.identifier
        tz = TZInfo::Timezone.get(tzid)
        timezone = tz.ical_timezone(event_start)
        calendar.add_timezone(timezone)
        event = Icalendar::Event.new.tap do |e|
          e.dtstart = Icalendar::Values::DateTime.new(event_start, "tzid" => tzid)
          e.dtend = Icalendar::Values::DateTime.new(event_end, "tzid" => tzid)
          e.summary = submission.full_title
          e.description = "#{submission.description}\n\nMore details: #{url}"
          e.location = submission.ical_location
          e.ip_class = "PUBLIC"
          e.created = submission.created_at
          e.last_modified = submission.updated_at
          e.uid = url
          e.url = url
        end
        calendar.add_event(event)
      end
      calendar.publish
    end
  end
end
