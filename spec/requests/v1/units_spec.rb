# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Units', type: :request do
  include Committee::Rails::Test::Methods

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:unit1) { create(:unit, user: user1) }
  let(:unit2) { create(:unit, user: user2) }

  describe 'GET /units' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_units_path }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      before { get v1_units_path, headers: { authorization: "Bearer #{token(user1)}" } }

      it { assert_schema_conform }
    end
  end

  describe 'GET /units/:id' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_unit_path(unit1) }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with own unit' do
        before { get v1_unit_path(unit1), headers: { authorization: "Bearer #{token(user1)}" } }

        it { assert_schema_conform }
      end

      context 'with other\'s unit' do
        subject { response.status }

        before { get v1_unit_path(unit2), headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(404) }
      end
    end
  end

  describe 'POST /units' do
    context 'without authentication' do
      subject { response.status }

      let(:params) { attributes_for(:unit).merge!(unit_id: unit1.to_param) }

      before { post v1_units_path, params: params }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with valid params' do
        let(:params) { attributes_for(:unit) }

        before { post v1_units_path, params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { assert_schema_conform }
      end

      context 'with no label unit' do
        subject { response.status }

        let(:params) { attributes_for(:no_label_unit) }

        before { post v1_units_path, params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
      end

      context 'with existing label unit' do
        subject { response.status }

        let(:params) { attributes_for(:unit).merge!(user_id: user1.id) }

        before do
          Unit.create(params)
          post v1_units_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
      end
    end
  end

  describe 'PUT /units/:id' do
    context 'without authentication' do
      subject { response.status }

      let(:params) { attributes_for(:unit) }

      before { put v1_unit_path(unit1), params: params }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with own unit' do
        let(:params) { attributes_for(:unit) }

        before { put v1_unit_path(unit1), params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { assert_schema_conform }
      end

      context 'with other\'s unit' do
        subject { response.status }

        let(:params) { attributes_for(:unit) }

        before { put v1_unit_path(unit2), params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
      end

      context 'with no label unit' do
        subject { response.status }

        let(:params) { attributes_for(:no_label_unit) }

        before { put v1_unit_path(unit2), params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
      end

      context 'with existing label unit' do
        subject { response.status }

        let(:params) { attributes_for(:unit).merge!(user_id: user1.id) }

        before do
          Unit.create(params)
          put v1_unit_path(unit1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
      end

      context 'without renaming label of unit' do
        let(:params) { attributes_for(:unit).merge!(user_id: user1.id) }

        before { put v1_unit_path(unit1), params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { assert_schema_conform }
      end
    end
  end

  describe 'DELETE /units/:id' do
    context 'without authentication' do
      subject { response.status }

      before { delete v1_unit_path(unit1) }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with own unit' do
        context 'with unit not referenced by foods' do
          before { delete v1_unit_path(unit1), headers: { authorization: "Bearer #{token(user1)}" } }

          it { assert_schema_conform }
        end

        context 'with unit referenced by foods' do
          subject { response.status }

          let(:box) { create(:box, owner: user1) }

          before do
            create(:food, box: box,
                          unit: unit1,
                          created_user: user1,
                          updated_user: user1)
            delete v1_unit_path(unit1), headers: { authorization: "Bearer #{token(user1)}" }
          end

          it { is_expected.to eq(400) }
        end
      end

      context 'with other\'s unit' do
        subject { response.status }

        before { delete v1_unit_path(unit2), headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
      end
    end
  end
end
