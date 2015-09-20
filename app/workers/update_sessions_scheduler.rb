class UpdateSessionsScheduler

  def perform
    # Only schedule session updates on sundays
    if Date.today.wday == 0
      User.includes(:updates).find_each do |user|
        if user.user_ok?
          Delayed::Job.enqueue FetchSessionsWorker.new(user.id, false), priority: ApplicationWorker::PR_FETCH_SESSIONS, queue: ApplicationWorker::QUEUE_REGULAR
        end
      end
    end
  end

end