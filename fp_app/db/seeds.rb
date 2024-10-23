planner = Planner.create!(
  email: "fp_sample@example.com",
  password: "password",
  name: "fp_ex1",
  icon_path: "https://free-icon.org/material/02-illustration/0139-download-image-m.png",
  introduction: "はじめまして、フィナンシャルプランナーのfp_ex1です。ライフプラン設計や資産運用、保険の見直しなど、個々のニーズに合わせたご提案を心掛けています。お客様の将来設計をサポートし、安心できる生活を実現するため、誠心誠意お手伝いいたします。どうぞお気軽にご相談ください。"
)

planner2 = Planner.create!(
  email: "fp_sample2@example.com",
  password: "password",
  name: "fp_ex2",
  icon_path: "https://free-icon.org/material/02-illustration/0139-download-image-m.png",
  introduction: "はじめまして、フィナンシャルプランナーのfp_ex2です。ライフプラン設計や資産運用、保険の見直しなど、個々のニーズに合わせたご提案を心掛けています。お客様の将来設計をサポートし、安心できる生活を実現するため、誠心誠意お手伝いいたします。どうぞお気軽にご相談ください。"
)

planner3 = Planner.create!(
  email: "fp_sample3@example.com",
  password: "password",
  name: "fp_ex3",
  icon_path: "https://free-icon.org/material/02-illustration/0139-download-image-m.png",
  introduction: "はじめまして、フィナンシャルプランナーのfp_ex3です。ライフプラン設計や資産運用、保険の見直しなど、個々のニーズに合わせたご提案を心掛けています。お客様の将来設計をサポートし、安心できる生活を実現するため、誠心誠意お手伝いいたします。どうぞお気軽にご相談ください。"
)

planner4 = Planner.create!(
  email: "fp_sample4@example.com",
  password: "password",
  name: "fp_ex4",
  icon_path: "https://free-icon.org/material/02-illustration/0139-download-image-m.png",
  introduction: "はじめまして、フィナンシャルプランナーのfp_ex4です。ライフプラン設計や資産運用、保険の見直しなど、個々のニーズに合わせたご提案を心掛けています。お客様の将来設計をサポートし、安心できる生活を実現するため、誠心誠意お手伝いいたします。どうぞお気軽にご相談ください。"
)

planner5 = Planner.create!(
  email: "fp_sample5@example.com",
  password: "password",
  name: "fp_ex5",
  icon_path: "https://free-icon.org/material/02-illustration/0139-download-image-m.png",
  introduction: "はじめまして、フィナンシャルプランナーのfp_ex5です。ライフプラン設計や資産運用、保険の見直しなど、個々のニーズに合わせたご提案を心掛けています。お客様の将来設計をサポートし、安心できる生活を実現するため、誠心誠意お手伝いいたします。どうぞお気軽にご相談ください。"
)


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

schedule_times.each do |time|
  Schedule.create!(
    planner: planner,
    started_at: time[:started_at],
    is_available: time[:is_available]
  )
end

puts "seed created successfully."
