require 'faker'

100.times do |i|
  Planner.create!(
    email: "planner#{i}@example.com",
    password: "password",
    name: Faker::Name.name,
    icon_path: "https://free-icon.org/material/02-illustration/0139-download-image-m.png",
    introduction: "はじめまして、フィナンシャルプランナーの#{Faker::Name.name}です。ライフプラン設計や資産運用、保険の見直しなど、個々のニーズに合わせたご提案を心掛けています。お客様の将来設計をサポートし、安心できる生活を実現するため、誠心誠意お手伝いいたします。どうぞお気軽にご相談ください。"
  )
end

user = User.create!(
  email: "user_sample@example.com",
  password: "password",
  name: "user_ex",
  icon_path: "https://free-icon.org/material/02-illustration/0139-download-image-m.png"
)

schedule_times = [
  { started_at: (Time.now.beginning_of_week + 1.week) + 12.hours, is_available: true },
  { started_at: (Time.now.beginning_of_week + 1.week) + 13.hours, is_available: true },
  { started_at: (Time.now.beginning_of_week + 1.week) + 14.hours, is_available: true },
  { started_at: (Time.now.beginning_of_week + 1.week) + 15.hours, is_available: true },
  { started_at: (Time.now.beginning_of_week + 1.week) + 16.hours, is_available: true },
  { started_at: (Time.now.beginning_of_week + 1.week) + 17.hours, is_available: true }
]

Planner.all.each do |planner|
  schedule_times.each do |time|
    Schedule.create!(
      planner: planner,
      started_at: time[:started_at],
      is_available: time[:is_available]
    )
  end
end

Planner.all.sample(20).each do |planner|
  rand(1..5).times do
    schedule = planner.schedules.sample
    Appointment.create!(
      user: user,
      planner: planner,
      schedule: schedule,
      reserved_at: schedule.started_at,
      status: "done"
    )
  end
end

puts "100 planners, their schedules, and random appointments for random planners created successfully."
