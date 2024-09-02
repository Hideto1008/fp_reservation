# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  # ファクトリが有効かどうかのテスト
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  # バリデーションのテスト
  it "is valid with a valid email, password, name, and icon_path" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is invalid without an email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is invalid without a password" do
    user = build(:user, password: nil)
    expect(user).not_to be_valid
    expect(user.errors[:password]).to include("can't be blank")
  end

  it "is invalid with a duplicate email" do
    create(:user, email: "duplicate@example.com")
    user = build(:user, email: "duplicate@example.com")
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("has already been taken")
  end

end
