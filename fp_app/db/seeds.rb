planner = Planner.create!(
  email: "fp_sample@example.com",
  password: "password",
  name: "fp_ex",
  icon_path: "https://free-icon.org/material/02-illustration/0139-download-image-m.png",
  introduction: "はじめまして、フィナンシャルプランナーのfp_ex1です。ライフプラン設計や資産運用、保険の見直しなど、個々のニーズに合わせたご提案を心掛けています。お客様の将来設計をサポートし、安心できる生活を実現するため、誠心誠意お手伝いいたします。どうぞお気軽にご相談ください。"
)

schedule_times = [
	{ started_at: Time.new(2024, 9, 27, 10, 0, 0), is_available: true },
  { started_at: Time.new(2024, 10, 01, 10, 0, 0), is_available: true },
  { started_at: Time.new(2024, 10, 01, 11, 0, 0), is_available: true },
  { started_at: Time.new(2024, 10, 01, 13, 0, 0), is_available: true },
  { started_at: Time.new(2024, 10, 01, 14, 0, 0), is_available: true },
	{ started_at: Time.new(2024, 10, 01, 15, 0, 0), is_available: true },
	{ started_at: Time.new(2024, 10, 02, 16, 0, 0), is_available: true },
	{ started_at: Time.new(2024, 10, 02, 17, 0, 0), is_available: true }
]

schedule_times.each do |time|
  Schedule.create!(
    planner_id: planner.id,
    started_at: time[:started_at],
    is_available: time[:is_available]
  )
end

puts "Planner and schedules created successfully."
