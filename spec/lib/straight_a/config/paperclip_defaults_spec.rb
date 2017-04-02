# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StraightA::Config::PaperclipDefaults do
  describe '#category_defaults' do
    let(:paperclip_defaults) { described_class.new }
    subject(:category_defaults) { paperclip_defaults.category_defaults }

    let(:category_specific_settings) do
      {
        styles: hash_including(
          thumbnail: '100x100#',
          normal: '250x250>',
          large: '400x400>'
        ),
        default_style: 'normal'
      }
    end

    context 'if use_local_storage is set to true' do


      let(:local_storage_settings) do
        {
          storage: :fog,
          fog_credentials: hash_including(
            provider: 'Local',
            local_root: "#{Rails.root}/public"
          ),
          fog_directory: '',
          fog_host: 'localhost'
        }
      end

      before do
        paperclip_defaults.instance_variable_set(:@use_local_storage, true)
      end

      it { is_expected.to include category_specific_settings }

      it { is_expected.to include local_storage_settings }
    end

    context 'if use_local_storage is set to false' do
      before do
        paperclip_defaults.instance_variable_set(:@use_local_storage, false)
        ENV['S3_ACCESS_KEY_ID'] = 'FakeAccessID'
        ENV['S3_SECRET_ACCESS_KEY'] = 'FakeAccessSecretKey'
        ENV['PAPERCLIP_S3_BUCKET'] = 'FakeS3Bucket'
        ENV['PAPERCLIP_S3_BUCKET_REGION'] = 'FakeS3BucketRegion'
      end

      let(:s3_storage_settings) do
        {
          storage: :s3,
          s3_credentials: hash_including(
            access_key_id: 'FakeAccessID',
            secret_access_key: 'FakeAccessSecretKey',
            bucket: 'FakeS3Bucket'
          ),
          s3_protocol: :https,
          s3_region: 'FakeS3BucketRegion',
          s3_headers: { 'Cache-Control' => 'max-age=31557600' }
        }
      end

      it { is_expected.to include category_specific_settings }

      it { is_expected.to include s3_storage_settings }
    end
  end
end
