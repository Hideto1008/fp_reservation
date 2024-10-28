# spec/requests/appointments_spec.rb

require 'rails_helper'

RSpec.describe "Appointments", type: :request do
  include Devise::Test::IntegrationHelpers  # Include Devise test helpers

  let(:user) { create(:user) }
  let(:other_user) { create(:user, email: "other_user@example.com") }
  let(:planner) { create(:planner) }
  let(:other_planner) { create(:planner, email: "other_planner@example.com") }
  let(:schedule) { create(:schedule, planner: planner) }
  let(:available_schedule) { create(:schedule, :reserved_schedule, planner: planner) }
  let(:other_schedule) { create(:schedule, :reserved_schedule, planner: other_planner) }
  let(:past_schedule) { create(:schedule, planner: planner, started_at: Time.current - 1.day) }

  describe "POST /appointments" do
    context "when the user is not authenticated" do
      it "redirects to the sign-in page" do
        post appointments_path, params: { appointment: { user_id: user.id } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when the authenticated user is not the correct user" do
      before do
        sign_in other_user
      end

      it "redirects to the root page with an alert" do
        post appointments_path, params: { appointment: { user_id: user.id } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized")
      end
    end

    context "when the authenticated user is the correct user" do
      before do
        sign_in user
      end

      context "with valid parameters" do
        it "creates an appointment and shows a notice" do
          expect {
            post appointments_path, params: {
              appointment: {
                user_id: user.id,
                planner_id: planner.id,
                schedule_id: available_schedule.id,
                reserved_at: available_schedule.started_at,
                status: "reserved"
              }
            }
          }.to change(Appointment, :count).by(1)
          expect(response).to redirect_to(user_path(user))
          expect(flash[:notice]).to eq("Appointment created successfully.")
          expect(available_schedule.reload.is_available).to be_falsey
        end
      end

      context "with invalid parameters" do
        it "does not create an appointment and shows an error message when the schedule is not available" do
          expect {
            post appointments_path, params: {
              appointment: {
                user_id: user.id,
                planner_id: planner.id,
                schedule_id: schedule.id,
                reserved_at: schedule.started_at,
                status: "reserved"
              }
            }
          }.not_to change(Appointment, :count)
          expect(response).to redirect_to(user_path(user.id))
          expect(flash[:alert]).to eq("Unable to create appointment: Validation failed: Schedule is not available at the selected time")
        end

        it "does not create an appointment and shows an error message when make appointment in past" do
          expect {
            post appointments_path, params: {
              appointment: {
                user_id: user.id,
                planner_id: planner.id,
                schedule_id: past_schedule.id,
                reserved_at: past_schedule.started_at,
                status: "reserved"
              }
            }
          }.not_to change(Appointment, :count)
          expect(response).to redirect_to(user_path(user.id))
          expect(flash[:alert]).to include("Unable to create appointment: Validation failed: Reserved at can't be in the past")
        end

        it "does not create an appointment and shows an error message when the schedule duplicate" do
          create(:appointment, user: user, planner: planner, schedule: available_schedule, reserved_at: available_schedule.started_at)
          expect {
            post appointments_path, params: {
              appointment: {
                user_id: user.id,
                planner_id: other_planner.id,
                schedule_id: other_schedule.id,
                reserved_at: other_schedule.started_at,
                status: "reserved"
              }
            }
          }.not_to change(Appointment, :count)
          expect(response).to redirect_to(user_path(user.id))
          expect(flash[:alert]).to eq("Unable to create appointment: Validation failed: Already booked for the same date and time")
        end
      end
    end
  end
end
