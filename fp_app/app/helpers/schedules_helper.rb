module SchedulesHelper
  TIMES = (10..17).flat_map { |h| [ "00", "30" ].map { |m| "#{h}:#{m}" } }.freeze
  SATURDAY = 6

  def times
    TIMES
  end

  def is_saturday_available_time_slots(time)
    (time < "11:00" || time > "14:30")
  end

  def matching_schedule_or_blackout(day, time, schedules)
    if day.wday == SATURDAY && is_saturday_available_time_slots(time)
      content_tag(:span, "--", style: "background-color: black; color: white; font-size: 24px; padding: 10px;")
    else
      matching_schedule = schedules.find { |s| s.started_at.to_date == day && s.started_at.strftime("%H:%M") == time }
      if matching_schedule
        link_to(matching_schedule.is_available ? "◯" : "✖️", planner_schedule_path(planner_id: @planner.id, id: matching_schedule.id, is_available: !matching_schedule.is_available),
                method: :patch, remote: true, class: "toggle-availability",
                data: { schedule_id: matching_schedule.id },
                style: "font-size: 24px; color: #{matching_schedule.is_available ? '#4CAF50' : '#FF0000'};")
      else
        link_to("--", planner_schedules_path(planner_id: @planner.id, date: day, time: time),
                method: :post, remote: true, class: "toggle-availability",
                data: { schedule_id: nil, date: day.strftime("%Y-%m-%d"), time: time },
                style: "font-size: 24px; color: #FF0000;")
      end
    end
  end
end
