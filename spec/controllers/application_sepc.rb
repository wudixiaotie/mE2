require 'spec_helper'

describe ApplicationController do

  describe 'url_params_encode' do
    let(:params) { { id: 1, time: Time.new(2014, 03, 02, 12, 30, 0).to_i } }

    it 'should not include +' do
      expect(url_params_encode(params)).not_to match(/\+/)
    end

    it 'should not include \n' do
      expect(url_params_encode(params)).not_to match(/\\n/)
    end
  end

  describe 'url_params_decode' do
    let(:url_code) { 'ezppZD0%2BMSwgOnRpbWU9PjEzOTM3MzQ2MDB9%0A' }

    it 'should equal params' do
      expect do
        url_params_decode(url_code).to_s
      end.to match(/\{:id=>1, :time=>1393734600\}/)
    end

    it 'should be a hash' do
      expect do
        url_params_decode(url_code).class.to_s
      end.to match(/Hash/)
    end
  end
end