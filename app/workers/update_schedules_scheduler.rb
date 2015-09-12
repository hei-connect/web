class UpdateSchedulesScheduler

  def perform
    User.includes(:updates).find_each do |user|
      if user.user_ok? and user.is_eligible_for_schedule_update?
        Delayed::Job.enqueue FetchScheduleWorker.new(user.id),
                             priority: ApplicationWorker::PR_FETCH_SCHEDULE,
                             queue: ApplicationWorker::QUEUE_REGULAR
      end
    end
  end

end