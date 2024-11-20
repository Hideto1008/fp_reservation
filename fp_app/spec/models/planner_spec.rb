# spec/models/planner_spec.rb
require 'rails_helper'

RSpec.describe Planner, type: :model do
  describe 'test for devise validation' do
    EMAIL = "duplicate@example.com"
    # ファクトリが有効かどうかのテスト
    it "has a valid factory" do
      expect(build(:planner)).to be_valid
    end

    # バリデーションのテスト
    it "is valid with a valid email, password" do
      planner = build(:planner)
      expect(planner).to be_valid
    end

    it "is invalid without an email" do
      planner = build(:planner, email: nil)
      expect(planner).not_to be_valid
      expect(planner.errors[:email]).to include("can't be blank")
    end

    it "is invalid without a password" do
      planner = build(:planner, password: nil)
      expect(planner).not_to be_valid
      expect(planner.errors[:password]).to include("can't be blank")
    end

    it "is invalid with a duplicate email" do
      create(:planner, email: EMAIL)
      planner = build(:planner, email: EMAIL)
      expect(planner).not_to be_valid
      expect(planner.errors[:email]).to include("has already been taken")
    end
  end

  describe 'test for scope' do
    context 'with_done_appointments' do
      let!(:planner_with_many_done_appointmnts) { create(:planner) }
      let!(:planner_with_few_done_appointments) { create(:planner) }
      let!(:planner_without_done_appointments) { create(:planner) }
      let!(:user) { create(:user) }

      before do
        3.times do |i|
          create(:schedule, :reserved_schedule, planner: planner_with_many_done_appointmnts, started_at: (Time.now.beginning_of_week + 1.week) + (12 + i).hours)
        end
        create(:schedule, :reserved_schedule, planner: planner_with_few_done_appointments, started_at: (Time.now.beginning_of_week + 1.week) + 15.hours)
        create(:schedule, :reserved_schedule, planner: planner_without_done_appointments, started_at: (Time.now.beginning_of_week + 1.week) + 15.hours)

        planner_with_many_done_appointmnts.schedules.each do |schedule|
          create(:appointment, user: user, planner: planner_with_many_done_appointmnts, schedule: schedule, reserved_at: schedule.started_at, status: :done)
        end

        create(:appointment, user: user, planner: planner_with_few_done_appointments, schedule: planner_with_few_done_appointments.schedules.first, reserved_at: planner_with_few_done_appointments.schedules.first.started_at, status: :done)
        create(:appointment, user: user, planner: planner_without_done_appointments, schedule: planner_without_done_appointments.schedules.first, reserved_at: planner_without_done_appointments.schedules.first.started_at, status: :reserved)
      end

      it 'returns planners sorted by done appointments count' do
        planners = Planner.with_done_appointments

        expect(planners.first).to eq planner_with_many_done_appointmnts
        expect(planners.second).to eq planner_with_few_done_appointments
        expect(planners.last).to eq planner_without_done_appointments
      end
    end
  end
end
