module SchedulesHelper
  TIMES = [
    "10:00", "10:30", "11:00", "11:30",
    "12:00", "12:30", "13:00", "13:30",
    "14:00", "14:30", "15:00", "15:30",
    "16:00", "16:30", "17:00", "17:30"
  ].freeze

  def times
    TIMES
  end

  def matching_schedule_or_blackout(day, time, schedules)
    if day.wday == 6 && (time < '11:00' || time > '14:30')
      content_tag(:span, '--', style: 'background-color: black; color: white; font-size: 24px; padding: 10px;')
    else
      matching_schedule = schedules.find { |s| s.started_at.to_date == day && s.started_at.strftime('%H:%M') == time }
      if matching_schedule
        link_to(matching_schedule.is_available ? "◯" : "✖️", planner_schedule_path(planner_id: @planner.id, id: matching_schedule.id),
                method: :patch, remote: true, class: "toggle-availability",
                data: { schedule_id: matching_schedule.id },
                style: "font-size: 24px; color: #{matching_schedule.is_available ? '#4CAF50' : '#FF0000'};")
      else
        link_to("--", planner_schedules_path(planner_id: @planner.id, date: day, time: time),
                method: :post, remote: true, class: "toggle-availability",
                data: { schedule_id: nil, date: day.strftime('%Y-%m-%d'), time: time },
                style: "font-size: 24px; color: #FF0000;")
      end
    end
  end
end
