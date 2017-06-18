require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid_password?' do
    let(:user) { create(:user) }
    let(:password) { attributes_for(:user)[:password] }

    context 'with valid password' do
      subject { user.valid_password?(password) }

      it "returns truthy" do
        is_expected.to be_truthy
      end
    end

    context 'with invalid password' do
      subject { user.valid_password?("INVALID PASSWORD #{password}") }

      it "returns falsey" do
        is_expected.to be_falsey
      end
    end
  end

  describe '#invited_boxes' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:box) { create(:box, user: user1) }
    let!(:invitation) { Invitation.create(user: user2, box: box) }
    subject { user2.invited_boxes }

    it "returns invited boxes" do
      is_expected.to eq([box])
    end
  end

  describe '.find_for_database_authentication' do
    let(:user) { create(:user) }

    context 'if exists' do
      let(:condition) { { email: user.email } }
      subject { User.find_for_database_authentication(condition) }

      it "returns database user" do
        is_expected.to eq(user)
      end
    end

    context 'if not exists' do
      let(:condition) { { email: "nonexists-#{user.email}" } }
      subject { User.find_for_database_authentication(condition) }

      it "returns nil" do
        is_expected.to be_nil
      end
    end
  end

  describe '.find_for_google' do
    let(:auth) {
      {
        info: {
          name: 'test user',
          email: 'test@test.com'
        }
      }
    }
    let(:user) { User.find_for_google(auth) }

    it "returns google authorized user" do
      expect(user).to be_a(User)
      expect(user.provider).to eq('google')
    end
  end
end
