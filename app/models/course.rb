# encoding: utf-8
# == Schema Information
#
# Table name: courses
#
#  broken_name :string(255)
#  created_at  :datetime         not null
#  date        :datetime
#  ecampus_id  :integer
#  group_id    :integer
#  id          :integer          not null, primary key
#  kind        :string(255)
#  length      :integer
#  section_id  :integer
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_courses_on_ecampus_id  (ecampus_id)
#  index_courses_on_group_id    (group_id)
#  index_courses_on_section_id  (section_id)
#

class Course < ActiveRecord::Base
  UNKNOWN_PLACE = 'Lieu inconnu'
  UNKNOWN_DESCRIPTION = 'E-Campus ne donne pas plus d\'informations.'

  has_many :course_rooms, dependent: :delete_all
  has_many :rooms, through: :course_rooms
  has_many :course_teachers, dependent: :delete_all
  has_many :teachers, through: :course_teachers
  has_many :course_users, dependent: :delete_all
  has_many :users, through: :course_users

  belongs_to :section
  belongs_to :group

  attr_accessible :ecampus_id, :date, :length, :kind, :broken_name

  scope :current_weeks, -> { where("date >= ?", Time.zone.now.beginning_of_week).order("date ASC") }
  scope :today, -> { where("date(date) = DATE(?)", Time.zone.today).order("date ASC") }
  scope :tomorrow, -> { where("date(date) = DATE(?)", Time.zone.today + 1).order("date ASC") }

  def to_ical_event
    event = RiCal.Event
    event.dtstart = self.date
    event.dtend = self.date + self.length.minutes
    event.summary = self.name
    event.description = self.description
    event.location = self.place
    event.created = self.created_at.to_datetime
    event.last_modified = self.updated_at.to_datetime

    event
  end

  def to_fullcalendar_event
    {
        id: self.id,
        title: "#{name}, #{place}",
        start: self.date,
        end: self.date + self.length.minutes,
        allDay: false
    }
  end

  def name
    if self.broken_name.present?
      self.broken_name
    else
      "#{self.kind} - #{self.section.name}"
    end
  end

  def short_name
    if self.broken_name.present?
      self.broken_name
    else
      self.section.name
    end
  end

  def description
    if self.broken_name.present?
      UNKNOWN_DESCRIPTION
    else
      desc = "#{self.kind} de #{self.section.name}"
      if self.teachers.any?
        desc += "\r\nPar #{self.teachers.join ', '}."
      end

      desc
    end
  end

  def place
    if self.rooms.any?
      self.rooms.join ', '
    else
      UNKNOWN_PLACE
    end
  end

  def end_date
    self.date + self.length.minutes
  end

end
