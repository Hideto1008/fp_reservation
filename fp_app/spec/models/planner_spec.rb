# spec/models/planner_spec.rb
require 'rails_helper'

RSpec.describe Planner, type: :model do
  # ファクトリが有効かどうかのテスト
  it "has a valid factory" do
    expect(build(:planner)).to be_valid
  end

  # バリデーションのテスト
  it "is valid with a valid email, password, name, and icon_path" do
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
    create(:planner, email: "duplicate@example.com")
    planner = build(:planner, email: "duplicate@example.com")
    expect(planner).not_to be_valid
    expect(planner.errors[:email]).to include("has already been taken")
  end

  it "has a default name of 'planner'" do
    planner = create(:planner)
    expect(planner.name).to eq("planner")
  end

  it "has a default icon_path of an empty string" do
    planner = create(:planner)
    expect(planner.icon_path).to eq("")
  end
end
