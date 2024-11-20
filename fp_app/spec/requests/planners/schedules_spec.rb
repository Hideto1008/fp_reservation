require 'rails_helper'

RSpec.describe "Planners::Schedules", type: :request do
  let(:user) { create(:user) }
  let(:planner) { create(:planner) }
  let(:other_planner) { create(:planner, email: "other@example.com") }
  let(:schedule) { create(:schedule, planner: planner) }
  let(:available_schedule) { create(:schedule, :reserved_schedule, planner: planner) }

  describe "GET /planners/:planner_id/schedule" do
    before do
      sign_in planner
    end

    context "when accessing own schedule" do
      it "returns a successful response" do
        get planner_schedules_path(planner)
        expect(response).to have_http_status(:success)
      end
    end

    context "when accessing another planner's schedule" do
      it "redirects to root_path" do
        get planner_schedules_path(other_planner)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /planners/:planner_id/schedules" do
    before do
      sign_in planner
    end

    let(:valid_params) { { date: Date.today.beginning_of_week + 1.week, time: "13:00" } }

    context "when creating a schedule with valid params" do
      it "creates a new schedule and renders the correct template" do
        expect {
          post planner_schedules_path(planner), params: valid_params, xhr: true
        }.to change(Schedule, :count).by(1)
        expect(response).to have_http_status(:success)
        expect(response).to render_template("planners/schedules/update_schedule")
      end
    end

    context "when creating a schedule for another planner" do
      it "redirects to root_path" do
        expect {
          post planner_schedules_path(other_planner), params: valid_params, xhr: true
        }.not_to change { Schedule.count }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /planners/:planner_id/schedules/:id/" do
    before do
      sign_in planner
    end

    context "when updating own schedule" do
      it "toggles the availability of the schedule" do
        expect {
          patch planner_schedule_path(planner, schedule), params: { is_available: !schedule.is_available }, xhr: true
          schedule.reload
        }.to change { schedule.is_available }.from(schedule.is_available).to(!schedule.is_available)

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("text/javascript; charset=utf-8")
      end
    end

    context "when updating another planner's schedule" do
      let(:other_schedule) { create(:schedule, planner: other_planner) }

      it "redirects to root_path" do
        patch planner_schedule_path(other_planner, other_schedule), xhr: true
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /schedules/:id" do
    context "when schedule is associated with a reserved appointment" do
      before do
        sign_in user
      end

      it "does not update the schedule and shows an alert" do
        post appointments_path, params: {
          appointment: {
            user_id: user.id,
            planner_id: planner.id,
            schedule_id: available_schedule.id,
            reserved_at: available_schedule.started_at,
            status: "reserved"
          }
        }
        expect(available_schedule.reload.is_available).to be_falsey

        expect {
          patch planner_schedule_path(planner, available_schedule), params: { is_available: !available_schedule.is_available }, xhr: true
          schedule.reload
        }.not_to change { available_schedule.is_available }

        expect(available_schedule.reload.is_available).to be_falsey
      end
    end
  end
end
