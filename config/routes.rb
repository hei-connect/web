HeiConnectWeb::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get 'ics/:key' => 'ics#show', as: :ics

  scope '/dashboard/:ecampus_id' do
    get '' => 'dashboard#index', as: :dashboard
    get 'courses' => 'dashboard#courses', as: :dashboard_courses
    get 'grades/:year/:try' => 'dashboard#grades', as: :dashboard_grades
    put 'grades/:year/:try' => 'dashboard#update_grades'
    get 'absences/:year/:try' => 'dashboard#absences', as: :dashboard_absences
    put 'absences/:year/:try' => 'dashboard#update_absences'
  end

  resource :sessions, only: [:destroy]
  # Should be improved
  get 'sessions' => 'sessions#destroy' if Rails.env.test?

  resource :users, only: [:create] do
    get 'validate'
  end

  get 'about' => 'welcome#about'
  get 'status' => 'welcome#status'

  scope module: 'api/v1', path: 'api/v1', constraints: {:format => /(json|xml)/} do
    get 'config' => 'config#index'
    post 'login' => 'login#index'
    get 'schedule/today' => 'schedule#index'
    get 'schedule/tomorrow' => 'schedule#tomorrow'
    get 'grades' => 'grades#index'
    get 'absences' => 'absences#index'
  end


  root :to => 'welcome#index'
end
