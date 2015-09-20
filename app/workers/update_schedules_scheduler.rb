class UpdateSchedulesScheduler

  def perform
    wday = Date.today.wday
    # Do not update schedule on sundays
    if wday != 0
      User.includes(:updates).find_each do |user|
        if user.user_ok? and user.is_eligible_for_schedule_update?
          Delayed::Job.enqueue FetchScheduleWorker.new(user.id),
                               priority: ApplicationWorker::PR_FETCH_SCHEDULE,
                               queue: ApplicationWorker::QUEUE_REGULAR
        end
      end
    end
  end

end