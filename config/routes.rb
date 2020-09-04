require "sidekiq/web"
require "sidecloq/web"

Rails.application.routes.draw do
  if Rails.env.development?
    mount MailPreview => "mailers"
  end

  # Helpscout sidebar hook
  get "helpscout_hooks/show"
  post "/helpscout_hook", to: "helpscout_hooks#create", as: :helpscout_hook

  # Admin tools
  authenticate :user, ->(u) { u.is_admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  ActiveAdmin.routes(self)

  # Redirects for old paths
  get "/get-involved/team", to: redirect("/about/team")
  get "/get-involved/faq", to: redirect("/about/faq")
  get "/contact/press", to: redirect("/press")
  get "/contact/assets", to: redirect("about/assets")
  get "/assets", to: redirect("about/assets")
  get "/faq", to: redirect("/about/faq")
  get "/contact", to: redirect("/general_inquiries/new")

  get "/resources", to: redirect("/program")
  get "/about/ambassadors", to: redirect("/initiatives/ambassadors")
  get "/program/ambassadors", to: redirect("/initiatives/ambassadors")
  get "/about/clusters", to: redirect("/program/clusters")
  get "/about/previous", to: redirect("/program/previous")
  get "/about/tracks", to: redirect("/program/tracks")
  get "/about/youth", to: redirect("/initiatives/youth")
  get "/program/youth", to: redirect("/initiatives/youth")
  get "/panel-picker/mine", to: redirect("/dashboard")
  get "/voting/mine", to: redirect("/dashboard")
  get "/panel-picker", to: redirect("/voting")
  get "/panel-picker/search", to: redirect("/voting")
  get "/panel-picker/track", to: redirect("/voting")

  # Vanity redirects
  get "/live", to: redirect("https://dswlive.intelivideo.com/")
  get "/publishme", to: redirect("/get-involved/content")

  devise_for :users, controllers: {registrations: "users/registrations",
                                   sessions: "users/sessions",
                                   passwords: "users/passwords"}

  resource :registration, only: %i[new create] do
    collection do
      get :closed
      get :confirm
    end
  end

  resources :submissions, except: [:destroy], path: "voting", path_names: {new: "submit"} do
    collection do
      get :thanks
      get :by_day
      get :feedback_closed
      get :faq
    end
    resources :votes, only: :create
    resources :comments, only: :create
  end

  resources :feedback, only: %i[new create]
  resources :venues, only: [:edit, :update]
  resources :venue_availabilities, except: [:destroy]

  resource :dashboard, only: :show

  resources :newsletter_signups, only: :create
  resources :general_inquiries, path: "general-inquiry", only: [:create, :new]
  resources :job_fair_signups, path: "job-fair-signups", only: [:create, :new]
  resources :sponsor_signups, only: :create

  resources :articles, except: [:destroy]

  scope :program do
    resources :clusters, only: :show, param: :name
    resources :tracks, only: :show, param: :name
  end

  get "/schedule", to: "schedules#index", as: :schedules
  get "/schedule/:year",
    to: "schedules#index",
    as: :schedules_by_year,
    constraints: {year: /\d{4}/},
    defaults: {year: Date.today.year}
  get "/schedule/:start_day",
    to: "schedules#by_day",
    as: :schedules_by_day,
    constraints: ->(r) { Submission::DAYS.invert.include?(r.params[:start_day].titleize) },
    defaults: {start_day: "monday", format: "html"}
  get "/schedule/:year/:start_day",
    to: "schedules#by_day",
    as: :schedules_by_year_by_day,
    constraints: ->(r) { Submission::DAYS.invert.include?(r.params[:start_day].titleize) && r.params[:year] =~ /\d{4}/ },
    defaults: {start_day: "monday", year: Date.today.year, format: "html"}
  get "/schedule/:id", to: "schedules#show", as: :schedule
  post "/schedule/:id", to: "schedules#create", as: :add_to_schedule
  delete "/schedule/:id", to: "schedules#destroy", as: :remove_from_schedule
  get "/schedule/:id/feed", to: "schedules#feed", as: :schedule_feed

  get "/register", to: "registrations#new", as: :register

  namespace :pitch_contest do
    resources :entries, only: :index do
      resources :votes, only: :create
    end
  end

  resource :company_search, only: %i[show] do
    collection do
      get :mine
    end
  end

  resource :user_search, only: %i[show]

  get "enable-simple-reg", to: "simple_registrations#enable", as: :enable_simple_reg
  get "disable-simple-reg", to: "simple_registrations#disable", as: :disable_simple_reg

  get "/auth/:provider/callback", to: "omniauth/sessions#create"

  get "/(*page)", to: "site#index", as: :page, defaults: {page: :index}
  root to: "site#index"
end
