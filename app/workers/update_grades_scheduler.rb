class UpdateGradesScheduler

  def perform
    wday = Date.today.wday
    # Only update grades if not on weekend
    if wday != 6 && wday != 0
      User.includes(:updates).find_each do |user|
        if user.user_ok? and user.main_session.present? and user.is_eligible_for_absences_or_grades_update?
          Delayed::Job.enqueue FetchDetailedGradesWorker.new(user.id, user.main_session.id),
                               priority: ApplicationWorker::PR_FETCH_DETAILED_GRADES,
                               queue: ApplicationWorker::QUEUE_DETAILED_GRADES
        end
      end
    end
  end

end